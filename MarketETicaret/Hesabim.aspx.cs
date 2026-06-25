using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MarketETicaret
{
    public partial class Hesabim : System.Web.UI.Page
    {
        // Veritabanı bağlantısı
        MarketETicaretDBEntities db = new MarketETicaretDBEntities();

        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. Oturum Kontrolü (Giriş yapmamışsa Login'e at)
            if (Session["MusteriID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                BilgileriGetir();
                SiparisleriGetir();
            }
        }

        private void BilgileriGetir()
        {
            int musteriId = Convert.ToInt32(Session["MusteriID"]);
            var musteri = db.Musteriler.Find(musteriId);

            if (musteri != null)
            {
                txtEmail.Text = musteri.Email;
                txtAd.Text = musteri.Ad;
                txtSoyad.Text = musteri.Soyad;
                txtTelefon.Text = musteri.Telefon;

                // ADRES satırı silindi (Veritabanında yok)
            }
        }

        private void SiparisleriGetir()
        {
            int musteriId = Convert.ToInt32(Session["MusteriID"]);

            // Müşterinin siparişlerini tarihe göre tersten (en yeni en üstte) getir
            var siparisler = db.Siparisler
                .Where(s => s.MusteriID == musteriId)
                .OrderByDescending(s => s.SiparisTarihi)
                .Select(s => new
                {
                    s.SiparisID,
                    s.SiparisTarihi,
                    s.ToplamTutar
                    // Durum kolonu silindi (Veritabanında yok)
                })
                .ToList();

            gridSiparisler.DataSource = siparisler;
            gridSiparisler.DataBind();
        }

        protected void btnGuncelle_Click(object sender, EventArgs e)
        {
            try
            {
                int musteriId = Convert.ToInt32(Session["MusteriID"]);
                var musteri = db.Musteriler.Find(musteriId);

                if (musteri != null)
                {
                    // 1. Temel Bilgileri Güncelle
                    musteri.Ad = txtAd.Text;
                    musteri.Soyad = txtSoyad.Text;
                    musteri.Telefon = txtTelefon.Text;

                    // ADRES güncelleme satırı silindi

                    // 2. Şifre Değiştirme Kontrolü
                    if (!string.IsNullOrEmpty(txtYeniSifre.Text))
                    {
                        // Eski şifreyi doğru girdi mi?
                        if (musteri.Sifre == txtEskiSifre.Text)
                        {
                            musteri.Sifre = txtYeniSifre.Text;
                        }
                        else
                        {
                            lblMesaj.Visible = true;
                            lblMesaj.CssClass = "alert alert-danger";
                            lblMesaj.Text = "Hata: Eski şifrenizi yanlış girdiniz!";
                            return; // İşlemi durdur
                        }
                    }

                    db.SaveChanges();

                    lblMesaj.Visible = true;
                    lblMesaj.CssClass = "alert alert-success";
                    lblMesaj.Text = "Bilgileriniz başarıyla güncellendi.";

                    // Şifre alanlarını temizle
                    txtEskiSifre.Text = "";
                    txtYeniSifre.Text = "";
                }
            }
            catch (Exception ex)
            {
                lblMesaj.Visible = true;
                lblMesaj.CssClass = "alert alert-danger";
                lblMesaj.Text = "Bir hata oluştu: " + ex.Message;
            }
        }
    }
}