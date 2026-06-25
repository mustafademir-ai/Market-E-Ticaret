using System;
using System.Linq;
using System.Web.UI;

namespace MarketETicaret
{
    public partial class HakkimizdaSayfasi : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                using (var db = new MarketETicaretDBEntities())
                {
                    var veri = db.Hakkimizda.FirstOrDefault();
                    if (veri != null)
                    {
                        // HTML içeriği Literal'e atıyoruz
                        ltrIcerik.Text = veri.Icerik;

                        // Düz metinleri Label'a atıyoruz
                        lblVizyon.Text = veri.Vizyon;
                        lblMisyon.Text = veri.Misyon;
                    }
                    else
                    {
                        ltrIcerik.Text = "<p>Henüz içerik eklenmemiş.</p>";
                    }
                }
            }
        }
    }
}