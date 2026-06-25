using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MarketETicaret
{
    public partial class AramaSonuc : System.Web.UI.Page
    {
        MarketETicaretDBEntities db = new MarketETicaretDBEntities();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // URL'den 'q' parametresini al (Örn: AramaSonuc.aspx?q=süt)
                string aranan = Request.QueryString["q"];

                if (!string.IsNullOrEmpty(aranan))
                {
                    // Güvenlik için boşlukları temizle
                    aranan = aranan.Trim();

                    lblArananKelime.Text = aranan;
                    UrunleriAra(aranan);
                }
                else
                {
                    // Eğer arama kelimesi yoksa ana sayfaya at
                    Response.Redirect("Default.aspx");
                }
            }
        }

        private void UrunleriAra(string kelime)
        {
            // Veritabanında Arama Yap (Ürün Adı VEYA Açıklama içinde geçiyorsa)
            // Ve ürün Aktif ise.
            var urunler = db.Urunler
                .Where(u => (u.UrunAdi.Contains(kelime) || u.Aciklama.Contains(kelime)) && u.Aktif == true)
                .OrderByDescending(u => u.EklenmeTarihi)
                .ToList();

            lblSonucSayisi.Text = urunler.Count.ToString();

            if (urunler.Count > 0)
            {
                rptUrunler.DataSource = urunler;
                rptUrunler.DataBind();
                pnlUrunYok.Visible = false;
                rptUrunler.Visible = true;
            }
            else
            {
                // Sonuç yoksa uyarı panelini göster
                pnlUrunYok.Visible = true;
                rptUrunler.Visible = false;
            }
        }

        protected void rptUrunler_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            // --- SEPETE EKLEME İŞLEMİ (Default.aspx ile aynı) ---
            if (e.CommandName == "SepeteEkle")
            {
                if (Session["MusteriID"] == null)
                {
                    // Giriş yapmamışsa Login'e at, dönüşte tekrar aramaya dönsün
                    string aranan = lblArananKelime.Text;
                    Response.Redirect("Login.aspx?returnUrl=AramaSonuc.aspx?q=" + aranan);
                    return;
                }

                int musteriId = Convert.ToInt32(Session["MusteriID"]);
                int urunId = Convert.ToInt32(e.CommandArgument);

                var sepet = db.Sepetler.FirstOrDefault(s => s.MusteriID == musteriId);

                // Sepet yoksa oluştur
                if (sepet == null)
                {
                    sepet = new Sepetler();
                    sepet.MusteriID = musteriId;
                    sepet.OlusturmaTarihi = DateTime.Now;
                    db.Sepetler.Add(sepet);
                    db.SaveChanges();
                }

                // Ürün sepette var mı?
                var sepettekiUrun = db.SepetUrunleri.FirstOrDefault(x => x.SepetID == sepet.SepetID && x.UrunID == urunId);

                if (sepettekiUrun != null)
                {
                    sepettekiUrun.Adet++;
                }
                else
                {
                    SepetUrunleri yeniUrun = new SepetUrunleri();
                    yeniUrun.SepetID = sepet.SepetID;
                    yeniUrun.UrunID = urunId;
                    yeniUrun.Adet = 1;
                    db.SepetUrunleri.Add(yeniUrun);
                }

                db.SaveChanges();

                // Sayfayı yenile ki sepet sayısı güncellensin
                Response.Redirect(Request.RawUrl);
            }
        }
    }
}