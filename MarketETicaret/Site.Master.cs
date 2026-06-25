using System;
using System.Linq;
using System.Web.UI;
using System.Web;

namespace MarketETicaret
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                OturumKontrolu();
                SepetAdediGetir();
                FooterBilgileriniGetir(); // Bu fonksiyonu çağırmayı unutma
            }
        }

        private void FooterBilgileriniGetir()
        {
            using (var db = new MarketETicaretDBEntities())
            {
                var iletisim = db.Iletisim.FirstOrDefault();

                if (iletisim != null)
                {
                    // 1. ADRES ve GOOGLE MAPS LINKI
                    ltrFooterAdres.Text = iletisim.Adres;
                    // Google Maps'te adresi aratan link oluşturuyoruz
                    // Server.UrlEncode, adresteki boşlukları ve Türkçe karakterleri linke uygun hale getirir.
                    string mapsUrl = "https://www.google.com/maps/search/?api=1&query=" + Server.UrlEncode(iletisim.Adres);
                    lnkFooterAdres.NavigateUrl = mapsUrl;

                    // 2. TELEFON
                    ltrFooterTelefon.Text = iletisim.Telefon;
                    // Telefon linki (boşlukları temizleyerek)
                    string telLink = iletisim.Telefon.Replace(" ", "").Replace("(", "").Replace(")", "");
                    lnkFooterTelefon.NavigateUrl = "tel:" + telLink;

                    // 3. E-MAIL
                    ltrFooterEmail.Text = iletisim.Email;
                    lnkFooterEmail.NavigateUrl = "mailto:" + iletisim.Email;
                }
                else
                {
                    ltrFooterAdres.Text = "Adres bilgisi bulunamadı.";
                }
            }
        }

        private void OturumKontrolu()
        {
            if (Session["MusteriID"] != null)
            {
                pnlGirisYok.Visible = false;
                pnlGirisVar.Visible = true;
                lblKullaniciAdi.Text = Session["AdSoyad"].ToString();
            }
            else
            {
                pnlGirisYok.Visible = true;
                pnlGirisVar.Visible = false;
            }
        }

        private void SepetAdediGetir()
        {
            if (Session["MusteriID"] != null)
            {
                int id = Convert.ToInt32(Session["MusteriID"]);
                using (var db = new MarketETicaretDBEntities())
                {
                    var sepet = db.Sepetler.FirstOrDefault(s => s.MusteriID == id);
                    if (sepet != null)
                    {
                        var adet = db.SepetUrunleri.Where(x => x.SepetID == sepet.SepetID).Sum(x => (int?)x.Adet) ?? 0;
                        lblSepetAdet.Text = adet.ToString();
                    }
                }
            }
        }

        protected void btnCikis_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            Response.Redirect("Default.aspx");
        }

        protected void btnAra_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(txtArama.Text))
            {
                Response.Redirect("AramaSonuc.aspx?q=" + txtArama.Text.Trim());
            }
        }
    }
}