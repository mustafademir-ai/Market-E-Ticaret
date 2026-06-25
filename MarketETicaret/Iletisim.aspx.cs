using System;
using System.Linq;
using System.Web.UI;

namespace MarketETicaret
{
    public partial class IletisimSayfasi : System.Web.UI.Page
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
            using (var db = new MarketETicaretDBEntities())
            {
                var veri = db.Iletisim.FirstOrDefault();
                if (veri != null)
                {
                    lblAdres.Text = veri.Adres;
                    lblTelefon.Text = veri.Telefon;
                    lblEmail.Text = veri.Email;
                    
                    // Harita kodunu direkt basıyoruz
                    // Eğer admin panelinden doğru iframe kodu girildiyse harita görünür.
                    ltrHarita.Text = veri.HaritaKodu;
                }
                else
                {
                    ltrHarita.Text = "<div class='alert alert-warning m-3'>Harita bilgisi girilmemiş.</div>";
                }
            }
        }
    }
}