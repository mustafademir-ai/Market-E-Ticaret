using System;
using System.Linq;
using System.Web.UI;

namespace MarketETicaret
{
    public partial class Register : System.Web.UI.Page
    {
        MarketETicaretDBEntities db = new MarketETicaretDBEntities();

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnKayitOl_Click(object sender, EventArgs e)
        {
            // Basit Validasyon
            if (string.IsNullOrWhiteSpace(txtAd.Text) || string.IsNullOrWhiteSpace(txtEmail.Text) || string.IsNullOrWhiteSpace(txtSifre.Text))
            {
                MesajGoster("Lütfen zorunlu alanları doldurunuz.", false);
                return;
            }

            // Email kontrolü (Aynı mailden var mı?)
            var kontrol = db.Musteriler.FirstOrDefault(x => x.Email == txtEmail.Text.Trim());
            if (kontrol != null)
            {
                MesajGoster("Bu E-Posta adresi zaten kayıtlı.", false);
                return;
            }

            try
            {
                // Yeni Müşteri Nesnesi
                Musteriler yeniMusteri = new Musteriler();
                yeniMusteri.Ad = txtAd.Text.Trim();
                yeniMusteri.Soyad = txtSoyad.Text.Trim();
                yeniMusteri.Email = txtEmail.Text.Trim();
                yeniMusteri.Sifre = txtSifre.Text.Trim(); // Gerçek projede şifrele (MD5/SHA)
                yeniMusteri.Telefon = txtTelefon.Text.Trim();
                yeniMusteri.KayitTarihi = DateTime.Now;
                yeniMusteri.Aktif = true;

                db.Musteriler.Add(yeniMusteri);
                db.SaveChanges();

                MesajGoster("Kayıt başarılı! Giriş sayfasına yönlendiriliyorsunuz...", true);

                // 2 Saniye sonra Giriş sayfasına at (HTML Meta Refresh veya JS ile yapılabilir ama burada basite indirgedik)
                Response.AddHeader("REFRESH", "2;URL=Login.aspx");
            }
            catch (Exception)
            {
                MesajGoster("Bir hata oluştu. Lütfen tekrar deneyin.", false);
            }
        }

        private void MesajGoster(string mesaj, bool basariliMi)
        {
            pnlMesaj.Visible = true;
            lblMesaj.Text = mesaj;
            pnlMesaj.CssClass = basariliMi ? "alert alert-success" : "alert alert-danger";
        }
    }
}