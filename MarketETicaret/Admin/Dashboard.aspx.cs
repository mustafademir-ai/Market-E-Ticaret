using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections.Generic;

namespace MarketETicaret.Admin
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                VerileriGetir();
            }
        }

        private void VerileriGetir()
        {
            using (var context = new MarketETicaretDBEntities())
            {
                try
                {
                    // --- 1. KART VERİLERİ ---

                    // Toplam Ciro
                    decimal ciro = context.Siparisler.Sum(x => (decimal?)x.ToplamTutar) ?? 0;
                    lblCiro.Text = ciro.ToString("C");

                    // Sayılar
                    lblSiparisSayisi.Text = context.Siparisler.Count().ToString();
                    lblMusteriSayisi.Text = context.Musteriler.Count().ToString();
                    lblUrunSayisi.Text = context.Urunler.Count().ToString();


                    // --- 2. TABLO VERİSİ (SON 5 SİPARİŞ) ---
                    var sonSiparisler = context.Siparisler
                        .OrderByDescending(x => x.SiparisID)
                        .Take(5)
                        .ToList() // Önce veriyi çekiyoruz (ToList), sonra işliyoruz.
                        .Select(x => new
                        {
                            x.SiparisID,
                            MusteriAdi = x.Musteriler != null ? x.Musteriler.Ad + " " + x.Musteriler.Soyad : "Silinmiş Müşteri",
                            x.ToplamTutar,
                            x.SiparisDurumu
                        }).ToList();

                    rptSonSiparisler.DataSource = sonSiparisler;
                    rptSonSiparisler.DataBind();


                    // --- 3. GRAFİK VERİLERİ ---

                    // A) AYLIK KAZANÇ (HATA ÇÖZÜMÜ BURADA)

                    // 1. ADIM: Tarihi dışarıda hesapla (LINQ hatasını engeller)
                    DateTime altiAyOnce = DateTime.Now.AddMonths(-6);

                    // 2. ADIM: Değişkeni sorguda kullan
                    var son6AySatis = context.Siparisler
                        .Where(x => x.SiparisTarihi != null && x.SiparisTarihi >= altiAyOnce)
                        .ToList() // Veritabanından veriyi buraya kadar çek
                                  // Buradan sonrası RAM'de çalışır, o yüzden hata vermez
                        .GroupBy(x => new { x.SiparisTarihi.Value.Year, x.SiparisTarihi.Value.Month })
                        .Select(g => new {
                            Tarih = g.Key.Month + "/" + g.Key.Year,
                            Tutar = g.Sum(x => (decimal?)x.ToplamTutar) ?? 0
                        })
                        .OrderBy(x => x.Tarih) // String sıralaması
                        .ToList();

                    if (son6AySatis.Count == 0)
                    {
                        hdnAylar.Value = "Veri Yok";
                        hdnKazanc.Value = "0";
                    }
                    else
                    {
                        hdnAylar.Value = string.Join(",", son6AySatis.Select(x => x.Tarih));
                        hdnKazanc.Value = string.Join(",", son6AySatis.Select(x => Math.Round((decimal)x.Tutar, 0)));
                    }

                    // B) KATEGORİ DAĞILIMI
                    var kategoriVerisi = context.Urunler
                        .Where(x => x.Kategoriler != null)
                        .GroupBy(x => x.Kategoriler.KategoriAdi)
                        .Select(g => new { Ad = g.Key, Sayi = g.Count() })
                        .ToList();

                    if (kategoriVerisi.Count > 0)
                    {
                        hdnKategoriIsimleri.Value = string.Join(",", kategoriVerisi.Select(x => x.Ad));
                        hdnKategoriDegerleri.Value = string.Join(",", kategoriVerisi.Select(x => x.Sayi));
                    }
                    else
                    {
                        hdnKategoriIsimleri.Value = "Kategori Yok";
                        hdnKategoriDegerleri.Value = "1";
                    }

                    // C) EN ÇOK SATAN ÜRÜNLER
                    var cokSatanlar = context.SiparisDetaylari
                        .Where(x => x.Urunler != null)
                        .GroupBy(x => x.Urunler.UrunAdi)
                        .Select(g => new { Urun = g.Key, Adet = g.Sum(x => (int?)x.Adet) ?? 0 })
                        .OrderByDescending(x => x.Adet)
                        .Take(5)
                        .ToList();

                    if (cokSatanlar.Count > 0)
                    {
                        hdnUrunIsimleri.Value = string.Join(",", cokSatanlar.Select(x => x.Urun));
                        hdnUrunSatis.Value = string.Join(",", cokSatanlar.Select(x => x.Adet));
                    }
                    else
                    {
                        hdnUrunIsimleri.Value = "Satış Yok";
                        hdnUrunSatis.Value = "0";
                    }

                }
                catch (Exception ex)
                {
                    // Hata olursa ekranda görelim
                    lblCiro.Text = "Err: " + ex.Message;
                    lblCiro.ForeColor = System.Drawing.Color.Red;
                    lblCiro.Font.Size = 10;
                }
            }
        }
    }
}