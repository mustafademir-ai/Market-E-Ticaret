using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.HtmlControls;

namespace MarketETicaret
{
    public partial class Urunler : Page
    {
        private MarketETicaretDBEntities db = new MarketETicaretDBEntities();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int kategoriID = 0;
                string ara = Request.QueryString["Ara"];

                if (int.TryParse(Request.QueryString["KategoriID"], out kategoriID))
                {
                    var kategori = db.Kategoriler.FirstOrDefault(k => k.KategoriID == kategoriID && k.Aktif == true);
                    if (kategori != null)
                    {
                        lblBaslik.InnerText = "Kategori: " + kategori.KategoriAdi;
                        UrunleriGetir(u => u.KategoriID == kategoriID && u.Aktif == true);
                    }
                }
                else if (!string.IsNullOrEmpty(ara))
                {
                    lblBaslik.InnerText = "Arama Sonuçları: " + ara;
                    UrunleriGetir(u => u.UrunAdi.Contains(ara) && u.Aktif == true);
                }
                else
                {
                    lblBaslik.InnerText = "Tüm Ürünler";
                    UrunleriGetir(u => u.Aktif == true);
                }
            }
        }

        private void UrunleriGetir(Func<Urunler, bool> filtre)
        {
            urunKartiContainer.Controls.Clear();

            var urunler = db.Urunler.Where(filtre).ToList();

            foreach (var u in urunler)
            {
                HtmlGenericControl div = new HtmlGenericControl("div");
                div.Attributes["class"] = "col-md-3 mb-4";

                // Sepete ekle butonuna ID ve OnServerClick ekliyoruz
                string btnID = "btnSepeteEkle_" + u.UrunID;
                HtmlButton btn = new HtmlButton();
                btn.ID = btnID;
                btn.InnerText = "Sepete Ekle";
                btn.Attributes["class"] = "btn btn-primary";
                btn.ServerClick += (s, e) => SepeteEkle(u.UrunID);

                div.InnerHtml = $@"
                <div class='card h-100'>
                    <img src='{u.ResimYolu}' class='card-img-top' alt='{u.UrunAdi}' style='height:200px; object-fit:cover;'/>
                    <div class='card-body'>
                        <h5 class='card-title'>{u.UrunAdi}</h5>
                        <p class='card-text'>{u.Fiyat:C}</p>
                    </div>
                </div>";

                div.Controls.Add(btn); // Butonu ekliyoruz

                urunKartiContainer.Controls.Add(div);
            }

            if (urunler.Count == 0)
            {
                HtmlGenericControl p = new HtmlGenericControl("p");
                p.InnerText = "Bu kategoride ürün bulunamadı.";
                urunKartiContainer.Controls.Add(p);
            }
        }

        private void SepeteEkle(int urunID)
        {
            int? musteriID = Session["MusteriID"] as int?;
            if (musteriID == null)
            {
                // Kullanıcı giriş yapmamışsa mesaj
                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Lütfen giriş yapın.');", true);
                return;
            }

            // Kullanıcının aktif sepeti varsa onu al, yoksa oluştur
            var sepet = db.Sepetler.FirstOrDefault(s => s.MusteriID == musteriID && s.SepetUrunleri.Count() > 0);
            if (sepet == null)
            {
                sepet = new Sepetler { MusteriID = musteriID.Value, OlusturmaTarihi = DateTime.Now };
                db.Sepetler.Add(sepet);
                db.SaveChanges();
            }

            // Ürün sepette zaten varsa adet artır
            var sepettekiUrun = db.SepetUrunleri.FirstOrDefault(su => su.SepetID == sepet.SepetID && su.UrunID == urunID);
            if (sepettekiUrun != null)
            {
                sepettekiUrun.Adet += 1;
            }
            else
            {
                var yeniSepetUrun = new SepetUrunleri
                {
                    SepetID = sepet.SepetID,
                    UrunID = urunID,
                    Adet = 1
                };
                db.SepetUrunleri.Add(yeniSepetUrun);
            }

            db.SaveChanges();

            // Kullanıcıya mesaj göster
            ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Ürününüz sepete eklendi.');", true);
        }
    }
}
