using System;
using System.Linq;

using System.Web.UI;

using System.Web.UI.WebControls;



namespace MarketETicaret.Admin

{

    public partial class SiparisYonetimi : System.Web.UI.Page

    {

        protected void Page_Load(object sender, EventArgs e)

        {

            if (!IsPostBack)

            {

                SiparisleriListele();

                MusterileriDoldur();

            }

        }



        // --- LİSTELEME FONKSİYONU ---

        private void SiparisleriListele(string arama = "")

        {

            using (var context = new MarketETicaretDBEntities())

            {

                var sorgu = context.Siparisler.Include("Musteriler").AsQueryable();



                if (!string.IsNullOrEmpty(arama))

                {

                    int siparisNo;

                    bool sayiMi = int.TryParse(arama, out siparisNo);



                    if (sayiMi)

                    {

                        sorgu = sorgu.Where(x => x.SiparisID == siparisNo);

                    }

                    else

                    {

                        sorgu = sorgu.Where(x => x.Musteriler.Ad.Contains(arama) || x.Musteriler.Soyad.Contains(arama));

                    }

                }



                var liste = sorgu.OrderByDescending(x => x.SiparisTarihi)

                                 .ToList()

                                 .Select(x => new

                                 {

                                     x.SiparisID,

                                     MusteriAdi = x.Musteriler != null ? x.Musteriler.Ad + " " + x.Musteriler.Soyad : "Misafir / Silinmiş",

                                     x.SiparisTarihi,

                                     x.ToplamTutar,

                                     x.SiparisDurumu

                                 }).ToList();



                gridSiparisler.DataSource = liste;

                gridSiparisler.DataBind();

            }

        }



        private void MusterileriDoldur()

        {

            using (var context = new MarketETicaretDBEntities())

            {

                var musteriler = context.Musteriler

                    .Select(x => new { x.MusteriID, AdSoyad = x.Ad + " " + x.Soyad })

                    .ToList();



                ddlMusteri.DataSource = musteriler;

                ddlMusteri.DataTextField = "AdSoyad";

                ddlMusteri.DataValueField = "MusteriID";

                ddlMusteri.DataBind();

                ddlMusteri.Items.Insert(0, new ListItem("Müşteri Seçiniz...", "0"));

            }

        }



        protected void btnAra_Click(object sender, EventArgs e) { SiparisleriListele(txtAra.Text.Trim()); }

        protected void btnTemizle_Click(object sender, EventArgs e) { txtAra.Text = ""; SiparisleriListele(); }



        protected void btnYeniEkle_Click(object sender, EventArgs e)

        {

            pnlListe.Visible = false;

            pnlForm.Visible = true;

            lblFormBaslik.Text = "Yeni Sipariş Oluştur";

            FormuTemizle();

            ViewState["IslemID"] = "0";

        }



        protected void btnVazgec_Click(object sender, EventArgs e)

        {

            pnlForm.Visible = false;

            pnlListe.Visible = true;

            lblMesaj.Text = "";

        }



        private void FormuTemizle()

        {

            txtTutar.Text = "";

            if (ddlMusteri.Items.Count > 0) ddlMusteri.SelectedIndex = 0;

            ddlDurum.SelectedIndex = 0;

            lblMesaj.Text = "";

        }



        public string DurumRengi(string durum)

        {

            switch (durum)

            {

                case "Onaylandı": return "success";

                case "Hazırlanıyor": return "warning text-dark";

                case "Kargolandı": return "info text-dark";

                case "Teslim Edildi": return "primary";

                case "İptal": return "danger";

                default: return "secondary";

            }

        }



        // --- KAYDETME ---

        protected void btnKaydet_Click(object sender, EventArgs e)

        {

            using (var context = new MarketETicaretDBEntities())

            {

                context.Configuration.ValidateOnSaveEnabled = false;



                try

                {

                    int id = 0;

                    if (ViewState["IslemID"] != null) int.TryParse(ViewState["IslemID"].ToString(), out id);



                    MarketETicaret.Siparisler siparis;



                    if (id == 0)

                    {

                        siparis = new MarketETicaret.Siparisler();

                        siparis.SiparisTarihi = DateTime.Now;

                        context.Siparisler.Add(siparis);

                    }

                    else

                    {

                        siparis = context.Siparisler.FirstOrDefault(x => x.SiparisID == id);

                        if (siparis == null)

                        {

                            lblMesaj.Text = "Düzenlenecek sipariş bulunamadı.";

                            lblMesaj.CssClass = "alert alert-danger";

                            return;

                        }

                    }



                    siparis.SiparisDurumu = ddlDurum.SelectedValue;



                    decimal tutar = 0;

                    if (!string.IsNullOrEmpty(txtTutar.Text))

                    {

                        // Hem nokta hem virgülü kabul eder

                        string fiyatStr = txtTutar.Text.Replace(".", ",");

                        decimal.TryParse(fiyatStr, out tutar);

                    }

                    siparis.ToplamTutar = tutar;



                    int musId = 0;

                    int.TryParse(ddlMusteri.SelectedValue, out musId);



                    if (musId > 0)

                    {

                        siparis.MusteriID = musId;

                    }

                    else

                    {

                        if (id == 0)

                        {

                            lblMesaj.Text = "Lütfen bir müşteri seçiniz.";

                            lblMesaj.CssClass = "alert alert-warning";

                            return;

                        }

                    }



                    context.SaveChanges();



                    pnlForm.Visible = false;

                    pnlListe.Visible = true;

                    SiparisleriListele();

                    lblListeMesaj.Text = "<div class='alert alert-success'>İşlem başarıyla tamamlandı.</div>";

                }

                catch (Exception ex)

                {

                    string hata = ex.InnerException != null ? ex.InnerException.Message : ex.Message;

                    lblMesaj.Text = "Hata: " + hata;

                    lblMesaj.CssClass = "alert alert-danger";

                }

            }

        }



        // --- SİLME VE DÜZENLEME ---

        protected void gridSiparisler_RowCommand(object sender, GridViewCommandEventArgs e)

        {

            int id = Convert.ToInt32(e.CommandArgument);



            if (e.CommandName == "Sil")

            {

                using (var context = new MarketETicaretDBEntities())

                {

                    var siparis = context.Siparisler.Find(id);



                    if (siparis != null)

                    {

                        try

                        {

                            // --- 1. ADIM: ÖDEMELERİ SİL ---

                            // Siparişe bağlı ödemeler varsa önce bunları uçuruyoruz.

                            var odemeler = context.Odemeler.Where(x => x.SiparisID == id).ToList();

                            if (odemeler.Count > 0)

                            {

                                context.Odemeler.RemoveRange(odemeler);

                            }



                            // --- 2. ADIM: SİPARİŞ DETAYLARINI SİL (YENİ EKLENEN KISIM) ---

                            // Eğer veritabanında "SiparisDetaylari" veya "SiparisUrunleri" adında bir tablon varsa

                            // Siparişi silmeden önce içindeki ürünleri de silmelisin.

                            // NOT: Eğer tablonun adı 'SiparisDetaylari' değilse (örn: SiparisUrunler), alt satırı ona göre düzelt.



                            var detaylar = context.SiparisDetaylari.Where(x => x.SiparisID == id).ToList();

                            if (detaylar.Count > 0)

                            {

                                context.SiparisDetaylari.RemoveRange(detaylar);

                            }



                            // --- 3. ADIM: SİPARİŞİ SİL ---

                            context.Siparisler.Remove(siparis);



                            // Hepsini tek seferde veritabanına işle

                            context.SaveChanges();



                            lblListeMesaj.Text = "<div class='alert alert-success'>Sipariş, ürün detayları ve ödemeleri başarıyla silindi.</div>";

                        }

                        catch (Exception ex)

                        {

                            // Hatanın en derinindeki asıl sebebi bul (SQL hatasını görmek için)

                            Exception realError = ex;

                            while (realError.InnerException != null)

                            {

                                realError = realError.InnerException;

                            }



                            lblListeMesaj.Text = $"<div class='alert alert-danger'>Silinemedi! Hata Sebebi: {realError.Message}</div>";

                        }

                    }

                }

                // Listeyi güncelle

                SiparisleriListele();

            }

            else if (e.CommandName == "Duzenle")

            {

                // Düzenle kodları aynen kalacak...

                using (var context = new MarketETicaretDBEntities())

                {

                    var siparis = context.Siparisler.Find(id);

                    if (siparis != null)

                    {

                        pnlListe.Visible = false;

                        pnlForm.Visible = true;

                        lblFormBaslik.Text = "Sipariş Düzenle #" + id;

                        ViewState["IslemID"] = id.ToString();

                        lblMesaj.Text = "";



                        txtTutar.Text = siparis.ToplamTutar.ToString("N2").Replace(".", "");

                        ddlDurum.SelectedValue = siparis.SiparisDurumu;



                        if (siparis.MusteriID > 0)

                            ddlMusteri.SelectedValue = siparis.MusteriID.ToString();

                    }

                }

            }





        }

    }

}
