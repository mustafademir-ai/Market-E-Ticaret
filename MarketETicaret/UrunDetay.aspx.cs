using System;
using System.Linq;
using System.Web.UI;

namespace MarketETicaret
{
    public partial class UrunDetay : System.Web.UI.Page
    {
        MarketETicaretDBEntities db = new MarketETicaretDBEntities();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // URL'den ID al
                if (Request.QueryString["id"] != null)
                {
                    int id;
                    if (int.TryParse(Request.QueryString["id"], out id))
                    {
                        UrunGetir(id);
                    }
                    else
                    {
                        Response.Redirect("Default.aspx");
                    }
                }
                else
                {
                    Response.Redirect("Default.aspx");
                }
            }
        }

        private void UrunGetir(int id)
        {
            var urun = db.Urunler.Find(id);
            if (urun != null)
            {
                lblUrunAdi.Text = urun.UrunAdi;
                lblFiyat.Text = string.Format("{0:C}", urun.Fiyat);
                ltrAciklama.Text = urun.Aciklama;
                imgUrun.ImageUrl = urun.ResimYolu;

                // Kategori Adını bul (Navigation Property varsa)
                if (urun.Kategoriler != null)
                {
                    lblKategoriAdi.Text = urun.Kategoriler.KategoriAdi;
                }

                // Stok Durumu
                if (urun.Stok > 0)
                {
                    lblStokDurumu.Text = "Stokta Var (" + urun.Stok + ")";
                    lblStokDurumu.CssClass = "badge bg-success";
                    btnSepeteEkle.Enabled = true;
                }
                else
                {
                    lblStokDurumu.Text = "Tükendi";
                    lblStokDurumu.CssClass = "badge bg-danger";
                    btnSepeteEkle.Enabled = false;
                    btnSepeteEkle.Text = "Stok Yok";
                }
            }
            else
            {
                // Ürün bulunamadıysa ana sayfaya at
                Response.Redirect("Default.aspx");
            }
        }

        protected void btnSepeteEkle_Click(object sender, EventArgs e)
        {
            if (Session["MusteriID"] == null)
            {
                // Giriş yapmamışsa o anki sayfaya geri dönecek şekilde Login'e gönder
                string id = Request.QueryString["id"];
                Response.Redirect("Login.aspx?returnUrl=UrunDetay.aspx?id=" + id);
                return;
            }

            int musteriId = Convert.ToInt32(Session["MusteriID"]);
            int urunId = Convert.ToInt32(Request.QueryString["id"]);
            int adet = Convert.ToInt32(txtAdet.Text);

            // Adet kontrolü
            if (adet < 1) adet = 1;

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
                sepettekiUrun.Adet += adet; // Var olanın üzerine ekle
            }
            else
            {
                SepetUrunleri yeniUrun = new SepetUrunleri();
                yeniUrun.SepetID = sepet.SepetID;
                yeniUrun.UrunID = urunId;
                yeniUrun.Adet = adet;
                db.SepetUrunleri.Add(yeniUrun);
            }

            db.SaveChanges();

            // Sepet güncellensin diye sayfayı yenile
            Response.Redirect(Request.RawUrl);
        }
    }
}