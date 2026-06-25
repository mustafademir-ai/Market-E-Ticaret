using System;
using System.Linq;
using System.Web.UI;

namespace MarketETicaret.Admin
{
    public partial class IletisimYonetimi : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BilgileriGetir();
            }
        }

        private void BilgileriGetir()
        {
            using (var db = new MarketETicaretDBEntities())
            {
                var veri = db.Iletisim.FirstOrDefault();
                if (veri != null)
                {
                    txtAdres.Text = veri.Adres;
                    txtTelefon.Text = veri.Telefon;
                    txtEmail.Text = veri.Email;
                    txtHarita.Text = veri.HaritaKodu;

                    // Önizleme için
                    ltrHaritaOnizleme.Text = veri.HaritaKodu;
                }
            }
        }

        protected void btnKaydet_Click(object sender, EventArgs e)
        {
            using (var db = new MarketETicaretDBEntities())
            {
                // HTML kod (iframe) kaydedileceği için validasyonu kapatıyoruz
                db.Configuration.ValidateOnSaveEnabled = false;

                try
                {
                    var veri = db.Iletisim.FirstOrDefault();

                    if (veri == null)
                    {
                        veri = new Iletisim();
                        db.Iletisim.Add(veri);
                    }

                    veri.Adres = txtAdres.Text;
                    veri.Telefon = txtTelefon.Text;
                    veri.Email = txtEmail.Text;
                    veri.HaritaKodu = txtHarita.Text;

                    db.SaveChanges();

                    lblMesaj.Text = "İletişim bilgileri güncellendi.";
                    lblMesaj.CssClass = "alert alert-success";

                    // Önizlemeyi güncelle
                    ltrHaritaOnizleme.Text = txtHarita.Text;
                }
                catch (Exception ex)
                {
                    lblMesaj.Text = "Hata: " + ex.Message;
                    lblMesaj.CssClass = "alert alert-danger";
                }
            }
        }
    }
}