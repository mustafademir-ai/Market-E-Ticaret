using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MarketETicaret.Admin
{
    public partial class MusteriYonetimi : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                MusterileriListele();
            }
        }

        // --- LİSTELEME ---
        private void MusterileriListele(string arama = "")
        {
            using (var context = new MarketETicaretDBEntities())
            {
                var sorgu = context.Musteriler.AsQueryable();

                if (!string.IsNullOrEmpty(arama))
                {
                    sorgu = sorgu.Where(x => x.Ad.Contains(arama) || x.Soyad.Contains(arama) || x.Email.Contains(arama));
                }

                var liste = sorgu.OrderByDescending(x => x.MusteriID).ToList();

                gridMusteriler.DataSource = liste;
                gridMusteriler.DataBind();
            }
        }

        // --- BUTONLAR ---
        protected void btnAra_Click(object sender, EventArgs e) { MusterileriListele(txtAra.Text.Trim()); }
        protected void btnTemizle_Click(object sender, EventArgs e) { txtAra.Text = ""; MusterileriListele(); }

        protected void btnYeniEkle_Click(object sender, EventArgs e)
        {
            pnlListe.Visible = false;
            pnlForm.Visible = true;
            lblFormBaslik.Text = "Yeni Müşteri Ekle";
            FormuTemizle();
            ViewState["IslemID"] = "0";
        }

        protected void btnVazgec_Click(object sender, EventArgs e)
        {
            pnlForm.Visible = false;
            pnlListe.Visible = true;
        }

        private void FormuTemizle()
        {
            txtAd.Text = "";
            txtSoyad.Text = "";
            txtEmail.Text = "";
            txtTelefon.Text = "";
            txtSifre.Text = "";
            // txtAdres.Text = ""; // Veritabanında Adres olmadığı için kaldırdık
            lblMesaj.Text = "";
        }

        // --- KAYDETME ---
        protected void btnKaydet_Click(object sender, EventArgs e)
        {
            using (var context = new MarketETicaretDBEntities())
            {
                context.Configuration.ValidateOnSaveEnabled = false;

                try
                {
                    int id = 0;
                    if (ViewState["IslemID"] != null) int.TryParse(ViewState["IslemID"].ToString(), out id);

                    MarketETicaret.Musteriler musteri;

                    if (id == 0)
                    {
                        // --- YENİ KAYIT ---
                        musteri = new MarketETicaret.Musteriler();
                        musteri.KayitTarihi = DateTime.Now;

                        if (string.IsNullOrEmpty(txtSifre.Text))
                        {
                            lblMesaj.Text = "Yeni müşteri için şifre girmelisiniz.";
                            lblMesaj.CssClass = "alert alert-warning";
                            return;
                        }
                        musteri.Sifre = txtSifre.Text;

                        context.Musteriler.Add(musteri);
                    }
                    else
                    {
                        // --- GÜNCELLEME ---
                        musteri = context.Musteriler.FirstOrDefault(x => x.MusteriID == id);
                        if (musteri == null) return;

                        if (!string.IsNullOrEmpty(txtSifre.Text))
                        {
                            musteri.Sifre = txtSifre.Text;
                        }
                    }

                    // Diğer Bilgiler (Adres Kaldırıldı)
                    musteri.Ad = txtAd.Text;
                    musteri.Soyad = txtSoyad.Text;
                    musteri.Email = txtEmail.Text;
                    musteri.Telefon = txtTelefon.Text;

                    // musteri.Adres = txtAdres.Text; // HATA VEREN SATIR KALDIRILDI

                    context.SaveChanges();

                    pnlForm.Visible = false;
                    pnlListe.Visible = true;
                    MusterileriListele();
                    lblMesaj.Text = "";
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
        protected void gridMusteriler_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "Sil")
            {
                using (var context = new MarketETicaretDBEntities())
                {
                    var silinecek = context.Musteriler.Find(id);
                    if (silinecek != null)
                    {
                        try
                        {
                            context.Musteriler.Remove(silinecek);
                            context.SaveChanges();
                            MusterileriListele();
                        }
                        catch
                        {
                            Response.Write("<script>alert('Bu müşterinin sipariş kayıtları olduğu için silinemiyor.');</script>");
                        }
                    }
                }
            }
            else if (e.CommandName == "Duzenle")
            {
                using (var context = new MarketETicaretDBEntities())
                {
                    var musteri = context.Musteriler.Find(id);
                    if (musteri != null)
                    {
                        pnlListe.Visible = false;
                        pnlForm.Visible = true;
                        lblFormBaslik.Text = "Müşteri Düzenle";
                        ViewState["IslemID"] = id.ToString();

                        txtAd.Text = musteri.Ad;
                        txtSoyad.Text = musteri.Soyad;
                        txtEmail.Text = musteri.Email;
                        txtTelefon.Text = musteri.Telefon;
                        // txtAdres.Text = musteri.Adres; // HATA VEREN SATIR KALDIRILDI
                        txtSifre.Text = "";
                    }
                }
            }
        }
    }
}