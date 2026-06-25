using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.Entity; // Include için gerekli

namespace MarketETicaret
{
    public partial class Siparislerim : System.Web.UI.Page
    {
        MarketETicaretDBEntities db = new MarketETicaretDBEntities();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Giriş kontrolü
                if (Session["MusteriID"] == null)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                SiparisleriGetir();
            }
        }

        private void SiparisleriGetir()
        {
            int musteriId = Convert.ToInt32(Session["MusteriID"]);

            // Müşterinin siparişlerini tarihe göre tersten (en yeni en üstte) getir
            // Adres tablosunu da dahil ediyoruz (Include)
            var siparisler = db.Siparisler
                               .Include("Adresler")
                               .Where(s => s.MusteriID == musteriId)
                               .OrderByDescending(s => s.SiparisTarihi)
                               .Select(s => new
                               {
                                   s.SiparisID,
                                   s.SiparisTarihi,
                                   s.SiparisDurumu,
                                   s.ToplamTutar,
                                   // Adres silinmişse hata vermesin diye kontrol
                                   AdresBaslik = s.Adresler != null ? s.Adresler.AdresBaslik + " - " + s.Adresler.Sehir : "Adres Silinmiş"
                               })
                               .ToList();

            if (siparisler.Count > 0)
            {
                rptSiparisler.DataSource = siparisler;
                rptSiparisler.DataBind();
                pnlSiparisYok.Visible = false;
            }
            else
            {
                pnlSiparisYok.Visible = true;
            }
        }

        // BU METOD ÇOK ÖNEMLİ: İç içe Repeater doldurma işlemi
        protected void rptSiparisler_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            // Sadece veri satırlarında çalış (Header/Footer hariç)
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                // 1. O anki satırın Sipariş ID'sini bul
                // DataBinder.Eval ile o anki satırdaki veriyi okuyoruz
                int siparisId = Convert.ToInt32(DataBinder.Eval(e.Item.DataItem, "SiparisID"));

                // 2. İçerdeki Repeater'ı (rptDetaylar) bul
                Repeater rptDetaylar = (Repeater)e.Item.FindControl("rptDetaylar");

                // 3. O siparişe ait ürünleri veritabanından çek
                if (rptDetaylar != null)
                {
                    var detaylar = db.SiparisDetaylari
                                     .Include("Urunler")
                                     .Where(x => x.SiparisID == siparisId)
                                     .ToList()
                                     .Select(x => new
                                     {
                                         // Ürün silindiyse hata vermesin
                                         ResimYolu = x.Urunler != null ? x.Urunler.ResimYolu : "img/yok.png",
                                         UrunAdi = x.Urunler != null ? x.Urunler.UrunAdi : "Silinmiş Ürün",
                                         BirimFiyat = x.BirimFiyat, // O anki satın alma fiyatı
                                         Adet = x.Adet,
                                         SatirToplami = x.BirimFiyat * x.Adet
                                     })
                                     .ToList();

                    // 4. İçteki tabloyu doldur
                    rptDetaylar.DataSource = detaylar;
                    rptDetaylar.DataBind();
                }
            }
        }
    }
}