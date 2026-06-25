using System;
using System.Linq;
using System.Web.UI;

namespace MarketETicaret
{
    public partial class Login : System.Web.UI.Page
    {
        MarketETicaretDBEntities db = new MarketETicaretDBEntities();

        protected void Page_Load(object sender, EventArgs e)
        {
            // Zaten giriş yapmışsa Ana Sayfaya at
            if (Session["MusteriID"] != null)
            {
                Response.Redirect("Default.aspx");
            }
        }

        protected void btnGiris_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string sifre = txtSifre.Text.Trim();

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(sifre))
            {
                HataGoster("Lütfen tüm alanları doldurunuz.");
                return;
            }

            // Veritabanında kullanıcıyı ara
            var kullanici = db.Musteriler.FirstOrDefault(x => x.Email == email && x.Sifre == sifre && x.Aktif == true);

            if (kullanici != null)
            {
                // Giriş Başarılı - Session Oluştur
                Session["MusteriID"] = kullanici.MusteriID;
                Session["AdSoyad"] = kullanici.Ad + " " + kullanici.Soyad;
                Session["Email"] = kullanici.Email;

                // Sepet sayısını güncellemek için sayfayı yönlendir
                Response.Redirect("Default.aspx");
            }
            else
            {
                HataGoster("E-Posta veya Şifre hatalı!");
            }
        }

        private void HataGoster(string mesaj)
        {
            pnlHata.Visible = true;
            lblHata.Text = mesaj;
        }
    }
}