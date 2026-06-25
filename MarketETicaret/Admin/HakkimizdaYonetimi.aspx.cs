using System;
using System.Linq;
using System.Web.UI;

namespace MarketETicaret.Admin
{
    public partial class HakkimizdaYonetimi : System.Web.UI.Page
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
                // İlk kaydı getir (Tabloda tek kayıt olacak)
                var veri = db.Hakkimizda.FirstOrDefault();
                if (veri != null)
                {
                    txtVizyon.Text = veri.Vizyon;
                    txtMisyon.Text = veri.Misyon;
                    txtIcerik.Text = veri.Icerik;
                }
            }
        }

        protected void btnKaydet_Click(object sender, EventArgs e)
        {
            using (var db = new MarketETicaretDBEntities())
            {
                // HTML veri gönderileceği için güvenlik kontrolünü devre dışı bırakıyoruz (Sadece bu işlem için)
                db.Configuration.ValidateOnSaveEnabled = false;

                try
                {
                    // Var olan kaydı bul
                    var veri = db.Hakkimizda.FirstOrDefault();

                    if (veri == null)
                    {
                        // Kayıt yoksa yeni oluştur
                        veri = new Hakkimizda();
                        db.Hakkimizda.Add(veri);
                    }

                    // Verileri güncelle
                    veri.Vizyon = txtVizyon.Text;
                    veri.Misyon = txtMisyon.Text;
                    veri.Icerik = txtIcerik.Text; // CKEditor içeriği

                    db.SaveChanges();

                    lblMesaj.Text = "Başarıyla kaydedildi.";
                    lblMesaj.CssClass = "alert alert-success";
                }
                catch (Exception ex)
                {
                    string hata = ex.InnerException != null ? ex.InnerException.Message : ex.Message;
                    lblMesaj.Text = "Hata oluştu: " + hata;
                    lblMesaj.CssClass = "alert alert-danger";
                }
            }
        }
    }
}