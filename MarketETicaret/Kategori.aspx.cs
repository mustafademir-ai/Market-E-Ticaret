using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MarketETicaret
{
    public partial class Kategori : System.Web.UI.Page
    {
        MarketETicaretDBEntities db = new MarketETicaretDBEntities();

        // Tasarım tarafında (ASPX) hangi kategoride olduğumuzu boyamak için bu özelliği kullanacağız
        public int RequestKategoriID { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // URL'den ID'yi al (Örn: Kategori.aspx?id=3)
                if (Request.QueryString["id"] != null)
                {
                    int id;
                    // Güvenli çevirme (TryParse)
                    if (int.TryParse(Request.QueryString["id"], out id))
                    {
                        RequestKategoriID = id;
                        KategoriBilgisiniGetir(id);
                        UrunleriGetir(id);
                    }
                    else
                    {
                        // ID hatalıysa ana sayfaya at
                        Response.Redirect("Default.aspx");
                    }
                }
                else
                {
                    // ID hiç yoksa ana sayfaya at
                    Response.Redirect("Default.aspx");
                }

                SolMenuKategorileriGetir();
            }
        }

        private void SolMenuKategorileriGetir()
        {
            var kategoriler = db.Kategoriler.Where(x => x.Aktif == true).ToList();
            rptKategoriler.DataSource = kategoriler;
            rptKategoriler.DataBind();
        }

        private void KategoriBilgisiniGetir(int id)
        {
            var kategori = db.Kategoriler.Find(id);
            if (kategori != null)
            {
                lblKategoriAdi.Text = kategori.KategoriAdi;
                Page.Title = kategori.KategoriAdi + " - Ürünleri";
            }
        }

        private void UrunleriGetir(int id)
        {
            // Sadece o kategoriye ait ve aktif olan ürünleri getir
            var urunler = db.Urunler
                .Where(u => u.KategoriID == id && u.Aktif == true)
                .OrderByDescending(u => u.EklenmeTarihi)
                .ToList();

            if (urunler.Count > 0)
            {
                rptUrunler.DataSource = urunler;
                rptUrunler.DataBind();
                pnlUrunYok.Visible = false;
            }
            else
            {
                // Ürün yoksa uyarı panelini aç
                pnlUrunYok.Visible = true;
                rptUrunler.Visible = false;
            }
        }

        protected void rptUrunler_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            // --- ANA SAYFADAKİ SEPETE EKLEME MANTIĞININ AYNISI ---
            if (e.CommandName == "SepeteEkle")
            {
                if (Session["MusteriID"] == null)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                int musteriId = Convert.ToInt32(Session["MusteriID"]);
                int urunId = Convert.ToInt32(e.CommandArgument);

                var sepet = db.Sepetler.FirstOrDefault(s => s.MusteriID == musteriId);

                if (sepet == null)
                {
                    sepet = new Sepetler();
                    sepet.MusteriID = musteriId;
                    sepet.OlusturmaTarihi = DateTime.Now;
                    db.Sepetler.Add(sepet);
                    db.SaveChanges();
                }

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

                // Sepet sayısını güncellemek için sayfayı yenile
                Response.Redirect(Request.RawUrl);
            }
        }
    }
}