using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MarketETicaret
{
    public partial class Sepet : System.Web.UI.Page
    {
        MarketETicaretDBEntities db = new MarketETicaretDBEntities();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                SepetGetir();
            }
        }

        private void SepetGetir()
        {
            // HATA BURADAYDI: Eskiden int musteriID = 1; yazıyordu.
            // DÜZELTME: Artık giriş yapan kişinin ID'sini alıyoruz.

            if (Session["MusteriID"] == null)
            {
                // Eğer giriş yapmamışsa sepeti boş göster ve çık
                pnlSepetDolu.Visible = false;
                pnlSepetBos.Visible = true;
                return;
            }

            int musteriID = Convert.ToInt32(Session["MusteriID"]);

            // Kullanıcının sepetini bul
            var sepet = db.Sepetler.FirstOrDefault(s => s.MusteriID == musteriID);

            if (sepet != null)
            {
                // Sepetteki ürünleri çek
                var sepetUrunleri = db.SepetUrunleri
                    .Where(x => x.SepetID == sepet.SepetID)
                    .Select(x => new
                    {
                        x.SepetUrunID,
                        UrunAdi = x.Urunler.UrunAdi,
                        Resim = x.Urunler.ResimYolu,
                        Fiyat = x.Urunler.Fiyat,
                        Adet = x.Adet,
                        Tutar = x.Adet * x.Urunler.Fiyat
                    }).ToList();

                if (sepetUrunleri.Count > 0)
                {
                    pnlSepetDolu.Visible = true;
                    pnlSepetBos.Visible = false;

                    rptSepet.DataSource = sepetUrunleri;
                    rptSepet.DataBind();

                    // Toplam tutarı hesapla
                    decimal toplam = sepetUrunleri.Sum(x => x.Tutar);
                    lblToplamTutar.Text = toplam.ToString("C");
                }
                else
                {
                    pnlSepetDolu.Visible = false;
                    pnlSepetBos.Visible = true;
                }
            }
            else
            {
                // Kullanıcının hiç sepeti yoksa
                pnlSepetDolu.Visible = false;
                pnlSepetBos.Visible = true;
            }
        }

        protected void rptSepet_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Sil")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                var silinecek = db.SepetUrunleri.Find(id);

                if (silinecek != null)
                {
                    db.SepetUrunleri.Remove(silinecek);
                    db.SaveChanges();

                    // Listeyi yenile
                    SepetGetir();
                }
            }
        }
    }
}