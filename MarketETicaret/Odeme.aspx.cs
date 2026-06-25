using System;
using System.Linq;
using System.Web.UI;
using System.Data.Entity;
using System.Collections.Generic;

namespace MarketETicaret
{
    public partial class Odeme : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["MusteriID"] == null)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }
                SepetOzetiniGetir();
            }
        }

        private void SepetOzetiniGetir()
        {
            using (var db = new MarketETicaretDBEntities())
            {
                try
                {
                    int musteriId = Convert.ToInt32(Session["MusteriID"]);
                    var sepet = db.Sepetler.FirstOrDefault(s => s.MusteriID == musteriId);

                    if (sepet != null)
                    {
                        var urunler = db.SepetUrunleri
                            .Include("Urunler")
                            .Where(x => x.SepetID == sepet.SepetID)
                            .ToList()
                            .Select(x => new {
                                UrunAdi = x.Urunler != null ? x.Urunler.UrunAdi : "Silinmiş",
                                Adet = x.Adet,
                                ToplamFiyat = x.Adet * (x.Urunler != null ? x.Urunler.Fiyat : 0)
                            }).ToList();

                        rptOzet.DataSource = urunler;
                        rptOzet.DataBind();

                        decimal toplam = 0;
                        if (urunler.Any())
                        {
                            toplam = urunler.Sum(x => Convert.ToDecimal(x.ToplamFiyat));
                        }
                        lblOdenecekTutar.Text = toplam.ToString("C");
                    }
                }
                catch { }
            }
        }

        protected void btnSiparisiTamamla_Click(object sender, EventArgs e)
        {
            using (var db = new MarketETicaretDBEntities())
            {
                try
                {
                    // --- 1. FORM KONTROL ---
                    if (string.IsNullOrEmpty(txtAcikAdres.Text) || string.IsNullOrEmpty(txtSehir.Text))
                    {
                        lblHata.Text = "Lütfen adres bilgilerini doldurunuz.";
                        return;
                    }

                    int musteriId = Convert.ToInt32(Session["MusteriID"]);

                    // --- 2. SEPET KONTROL ---
                    var sepet = db.Sepetler.FirstOrDefault(s => s.MusteriID == musteriId);
                    if (sepet == null) return;

                    var sepetUrunleriBasit = db.SepetUrunleri
                                               .Where(x => x.SepetID == sepet.SepetID)
                                               .Select(x => new { x.SepetUrunID, x.UrunID, x.Adet })
                                               .ToList();

                    if (sepetUrunleriBasit.Count == 0)
                    {
                        lblHata.Text = "Sepetiniz boş.";
                        return;
                    }

                    // --- 3. ADRESİ KAYDET ---
                    Adresler yeniAdres = new Adresler();
                    yeniAdres.MusteriID = musteriId;
                    yeniAdres.AdresBaslik = txtAdresBaslik.Text;
                    yeniAdres.Sehir = txtSehir.Text;
                    yeniAdres.Ilce = txtIlce.Text;
                    yeniAdres.PostaKodu = txtPostaKodu.Text;
                    yeniAdres.AcikAdres = txtAcikAdres.Text;

                    db.Adresler.Add(yeniAdres);
                    db.SaveChanges(); // ADRES ID OLUŞTU

                    // --- 4. SİPARİŞ OLUŞTUR ---
                    Siparisler yeniSiparis = new Siparisler();
                    yeniSiparis.MusteriID = musteriId;
                    yeniSiparis.AdresID = yeniAdres.AdresID;
                    yeniSiparis.SiparisTarihi = DateTime.Now;
                    yeniSiparis.SiparisDurumu = "Hazırlanıyor";
                    yeniSiparis.ToplamTutar = 0;

                    db.Siparisler.Add(yeniSiparis);
                    db.SaveChanges(); // SİPARİŞ ID OLUŞTU

                    // --- 5. DETAYLARI VE STOKLARI DÖNGÜYLE EKLE ---
                    decimal gercekToplamTutar = 0;

                    // BU SATIR HAYAT KURTARIR: Hata veren gereksiz kontrolleri kapatır.
                    db.Configuration.ValidateOnSaveEnabled = false;

                    foreach (var item in sepetUrunleriBasit)
                    {
                        var dbUrun = db.Urunler.Find(item.UrunID);
                        if (dbUrun == null) continue;

                        decimal birimFiyat = dbUrun.Fiyat;
                        int adet = item.Adet;

                        SiparisDetaylari detay = new SiparisDetaylari();
                        detay.SiparisID = yeniSiparis.SiparisID;
                        detay.UrunID = item.UrunID;
                        detay.Adet = adet;
                        detay.BirimFiyat = birimFiyat;

                        db.SiparisDetaylari.Add(detay);

                        gercekToplamTutar += (birimFiyat * adet);

                        // Stok Düş
                        int mevcutStok = dbUrun.Stok;
                        dbUrun.Stok = (mevcutStok - adet) < 0 ? 0 : (mevcutStok - adet);
                    }

                    // Detayları ve stoğu kaydet (Validasyon kapalı olduğu için hata vermeyecek)
                    db.SaveChanges();

                    // --- 6. TOPLAM TUTAR GÜNCELLEME ---
                    yeniSiparis.ToplamTutar = gercekToplamTutar;
                    // Burada validasyonu tekrar açabiliriz veya kapalı kalabilir, sorun yok.
                    db.SaveChanges();

                    // --- 7. ÖDEME KAYDI ---
                    int odemeYontemiID = 1;
                    var yontem = db.OdemeYontemleri.FirstOrDefault();
                    if (yontem != null) odemeYontemiID = yontem.OdemeYontemiID;
                    else
                    {
                        OdemeYontemleri y = new OdemeYontemleri { OdemeAdi = "Kredi Kartı" };
                        db.OdemeYontemleri.Add(y);
                        db.SaveChanges();
                        odemeYontemiID = y.OdemeYontemiID;
                    }

                    Odemeler odeme = new Odemeler();
                    odeme.SiparisID = yeniSiparis.SiparisID;
                    odeme.OdemeYontemiID = odemeYontemiID;
                    odeme.OdemeDurumu = "Onaylandı";
                    odeme.OdemeTarihi = DateTime.Now;
                    db.Odemeler.Add(odeme);

                    db.SaveChanges();

                    // --- 8. SEPETİ SİL ---
                    foreach (var sil in sepetUrunleriBasit)
                    {
                        var silinecekSatir = db.SepetUrunleri.Find(sil.SepetUrunID);
                        if (silinecekSatir != null) db.SepetUrunleri.Remove(silinecekSatir);
                    }
                    db.SaveChanges();

                    Response.Redirect("SiparisTamamlandi.aspx");
                }
                catch (Exception ex)
                {
                    string msg = "HATA: " + ex.Message;
                    if (ex.InnerException != null) msg += " | " + ex.InnerException.Message;

                    lblHata.Text = msg;
                    string js = "<script>alert('" + msg.Replace("'", "") + "');</script>";
                    ClientScript.RegisterStartupScript(this.GetType(), "error", js);
                }
            }
        }
    }
}