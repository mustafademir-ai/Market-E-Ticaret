using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MarketETicaret.Admin
{
    public partial class KategoriYonetimi : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                KategorileriListele();
            }
        }

        // --- LİSTELEME ---
        private void KategorileriListele(string arama = "")
        {
            using (var context = new MarketETicaretDBEntities())
            {
                var sorgu = context.Kategoriler.AsQueryable();

                if (!string.IsNullOrEmpty(arama))
                {
                    sorgu = sorgu.Where(x => x.KategoriAdi.Contains(arama));
                }

                var liste = sorgu.OrderBy(x => x.KategoriAdi).ToList();

                gridKategoriler.DataSource = liste;
                gridKategoriler.DataBind();
            }
        }

        // --- BUTONLAR ---
        protected void btnAra_Click(object sender, EventArgs e) { KategorileriListele(txtAra.Text.Trim()); }
        protected void btnTemizle_Click(object sender, EventArgs e) { txtAra.Text = ""; KategorileriListele(); }

        protected void btnYeniEkle_Click(object sender, EventArgs e)
        {
            pnlListe.Visible = false;
            pnlForm.Visible = true;
            lblFormBaslik.Text = "Yeni Kategori Ekle";
            FormuTemizle();
            ViewState["IslemID"] = "0";
        }

        protected void btnVazgec_Click(object sender, EventArgs e)
        {
            pnlForm.Visible = false;
            pnlListe.Visible = true;
            lblListeMesaj.Text = ""; // Liste mesajını temizle
        }

        private void FormuTemizle()
        {
            txtKategoriAdi.Text = "";
            lblMesaj.Text = "";
        }

        // --- KAYDETME (Hata Korumalı) ---
        protected void btnKaydet_Click(object sender, EventArgs e)
        {
            using (var context = new MarketETicaretDBEntities())
            {
                context.Configuration.ValidateOnSaveEnabled = false;

                try
                {
                    int id = 0;
                    if (ViewState["IslemID"] != null) int.TryParse(ViewState["IslemID"].ToString(), out id);

                    MarketETicaret.Kategoriler kategori;

                    if (id == 0)
                    {
                        // --- YENİ KAYIT ---
                        kategori = new MarketETicaret.Kategoriler();

                        if (string.IsNullOrEmpty(txtKategoriAdi.Text))
                        {
                            lblMesaj.Text = "Kategori adı boş olamaz.";
                            lblMesaj.CssClass = "alert alert-warning";
                            return;
                        }

                        kategori.KategoriAdi = txtKategoriAdi.Text;
                        context.Kategoriler.Add(kategori);
                    }
                    else
                    {
                        // --- GÜNCELLEME ---
                        kategori = context.Kategoriler.FirstOrDefault(x => x.KategoriID == id);
                        if (kategori == null) return;

                        kategori.KategoriAdi = txtKategoriAdi.Text;
                    }

                    context.SaveChanges();

                    // Başarılı
                    pnlForm.Visible = false;
                    pnlListe.Visible = true;
                    KategorileriListele();
                    lblListeMesaj.Text = "<div class='alert alert-success alert-dismissible fade show'>İşlem başarıyla tamamlandı.<button type='button' class='btn-close' data-bs-dismiss='alert'></button></div>";
                }
                catch (Exception ex)
                {
                    string hata = ex.InnerException != null ? ex.InnerException.Message : ex.Message;
                    lblMesaj.Text = "Hata: " + hata;
                    lblMesaj.CssClass = "alert alert-danger";
                }
            }
        }

        // --- SİLME VE DÜZENLEME ---
        protected void gridKategoriler_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "Sil")
            {
                using (var context = new MarketETicaretDBEntities())
                {
                    var silinecek = context.Kategoriler.Find(id);
                    if (silinecek != null)
                    {
                        try
                        {
                            // ÖNEMLİ: Kategori silinmeden önce içinde ürün var mı bakıyoruz.
                            int urunSayisi = context.Urunler.Count(x => x.KategoriID == id);

                            if (urunSayisi > 0)
                            {
                                lblListeMesaj.Text = "<div class='alert alert-warning'><b>Silinemedi:</b> Bu kategoriye bağlı " + urunSayisi + " adet ürün var. Önce ürünleri silin veya kategorisini değiştirin.</div>";
                            }
                            else
                            {
                                context.Kategoriler.Remove(silinecek);
                                context.SaveChanges();
                                KategorileriListele();
                                lblListeMesaj.Text = "<div class='alert alert-success'>Kategori silindi.</div>";
                            }
                        }
                        catch (Exception ex)
                        {
                            lblListeMesaj.Text = "<div class='alert alert-danger'>Silme Hatası: " + ex.Message + "</div>";
                        }
                    }
                }
            }
            else if (e.CommandName == "Duzenle")
            {
                using (var context = new MarketETicaretDBEntities())
                {
                    var kategori = context.Kategoriler.Find(id);
                    if (kategori != null)
                    {
                        pnlListe.Visible = false;
                        pnlForm.Visible = true;
                        lblFormBaslik.Text = "Kategori Düzenle";
                        ViewState["IslemID"] = id.ToString();

                        txtKategoriAdi.Text = kategori.KategoriAdi;
                        lblListeMesaj.Text = ""; // Eski mesajları temizle
                    }
                }
            }
        }
    }
}