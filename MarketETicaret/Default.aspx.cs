using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MarketETicaret
{
    public partial class Default : System.Web.UI.Page
    {
        // Entity Framework Bağlantısı
        MarketETicaretDBEntities db = new MarketETicaretDBEntities();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                KategorileriGetir();
                UrunleriGetir();
            }
        }

        private void KategorileriGetir()
        {
            // Sadece aktif kategorileri getir
            var kategoriler = db.Kategoriler.Where(x => x.Aktif == true).ToList();
            rptKategoriler.DataSource = kategoriler;
            rptKategoriler.DataBind();
        }

        private void UrunleriGetir()
        {
            // BURASI GÜNCELLENDİ: SADECE ÖNE ÇIKANLARI GETİR
            var urunler = db.Urunler
                .Where(u => u.Aktif == true && u.OneCikan == true) // Kritik Nokta Burası
                .OrderByDescending(u => u.UrunID) // En son eklenenler/seçilenler üstte
                .Take(12) // Sayfa boğulmasın diye max 12 tane
                .Select(u => new
                {
                    u.UrunID,
                    u.UrunAdi,
                    u.Fiyat,
                    u.Stok,
                    u.ResimYolu,
                    KategoriAdi = u.Kategoriler.KategoriAdi
                })
                .ToList();

            // Eğer hiç öne çıkan ürün yoksa panel görünsün diye kontrol (Opsiyonel)
            if (urunler.Count == 0)
            {
                pnlUrunYok.Visible = true;
            }
            else
            {
                pnlUrunYok.Visible = false;
                rptUrunler.DataSource = urunler;
                rptUrunler.DataBind();
            }
        }

        protected void rptUrunler_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            // Sepete Ekle Butonuna Basıldığında Çalışır
            if (e.CommandName == "SepeteEkle")
            {
                // 1. Kullanıcı Giriş Kontrolü
                if (Session["MusteriID"] == null)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                int musteriId = Convert.ToInt32(Session["MusteriID"]);
                int urunId = Convert.ToInt32(e.CommandArgument);

                // 2. Müşterinin Sepetini Bul veya Oluştur
                var sepet = db.Sepetler.FirstOrDefault(s => s.MusteriID == musteriId);

                if (sepet == null)
                {
                    sepet = new Sepetler();
                    sepet.MusteriID = musteriId;
                    sepet.OlusturmaTarihi = DateTime.Now;
                    db.Sepetler.Add(sepet);
                    db.SaveChanges();
                }

                // 3. Ürünü Sepete Ekle
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
                Response.Redirect(Request.RawUrl);
            }
        }
    }
}