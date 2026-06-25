using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace MarketETicaret.Admin
{
    public partial class UrunYonetimi : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                UrunleriListele();
                KategorileriDoldur();
            }
        }

        // --- ÜRÜNLERİ GETİR ---
        private void UrunleriListele(string aramaKelimesi = "")
        {
            using (var context = new MarketETicaretDBEntities())
            {
                context.Configuration.LazyLoadingEnabled = false;

                var sorgu = context.Urunler.Include("Kategoriler").AsQueryable();

                if (!string.IsNullOrEmpty(aramaKelimesi))
                {
                    sorgu = sorgu.Where(x => x.UrunAdi.Contains(aramaKelimesi));
                }

                var urunler = sorgu.OrderByDescending(x => x.UrunID)
                                   .ToList()
                                   .Select(x => new
                                   {
                                       x.UrunID,
                                       x.UrunAdi,
                                       x.Fiyat,
                                       x.Stok,
                                       x.Aktif,
                                       OneCikan = x.OneCikan != null && (bool)x.OneCikan,
                                       ResimYolu = string.IsNullOrEmpty(x.ResimYolu) ? "https://via.placeholder.com/50" : x.ResimYolu,
                                       KategoriAdi = x.Kategoriler != null ? x.Kategoriler.KategoriAdi : "Kategorisiz"
                                   }).ToList();

                gridUrunler.DataSource = urunler;
                gridUrunler.DataBind();
            }
        }

        private void KategorileriDoldur()
        {
            using (var context = new MarketETicaretDBEntities())
            {
                var kategoriler = context.Kategoriler.ToList();
                ddlKategori.DataSource = kategoriler;
                ddlKategori.DataTextField = "KategoriAdi";
                ddlKategori.DataValueField = "KategoriID";
                ddlKategori.DataBind();
                ddlKategori.Items.Insert(0, new ListItem("Kategori Seçiniz...", "0"));
            }
        }

        // --- LİSTE ÜZERİNDEN HIZLI ÖNE ÇIKARMA (BURASI HATAYI ÇÖZEN KOD) ---
        protected void chkGridOneCikan_CheckedChanged(object sender, EventArgs e)
        {
            try
            {
                CheckBox chk = sender as CheckBox;
                if (chk == null) return;

                // ToolTip'ten ID'yi okuyoruz. Eğer boşsa işlemi durdur.
                if (string.IsNullOrEmpty(chk.ToolTip)) return;

                int id = 0;
                // ID'yi sayıya çevirmeyi dene, başaramazsan işlemi durdur.
                if (!int.TryParse(chk.ToolTip, out id)) return;

                bool yeniDurum = chk.Checked;

                using (var context = new MarketETicaretDBEntities())
                {
                    var urun = context.Urunler.Find(id);

                    // KORUMA: Eğer veritabanında ürün bulunduysa işlemi yap.
                    // Ürün yoksa (null ise) hiçbir şey yapma. Hata vermez.
                    if (urun != null)
                    {
                        urun.OneCikan = yeniDurum;
                        context.SaveChanges();
                    }
                }

                // Listeyi yenile
                UrunleriListele(txtAra.Text.Trim());
            }
            catch
            {
                // Kritik olmayan hata, sessizce geç
            }
        }

        // --- KAYDET / GÜNCELLE ---
        protected void btnKaydet_Click(object sender, EventArgs e)
        {
            using (var context = new MarketETicaretDBEntities())
            {
                context.Configuration.ValidateOnSaveEnabled = false;

                try
                {
                    int id = 0;
                    if (ViewState["IslemID"] != null) int.TryParse(ViewState["IslemID"].ToString(), out id);

                    MarketETicaret.Urunler urun;

                    if (id == 0)
                    {
                        // YENİ KAYIT
                        urun = new MarketETicaret.Urunler();
                        urun.EklenmeTarihi = DateTime.Now;
                        urun.OneCikan = false;
                        urun.Aktif = true;
                        context.Urunler.Add(urun);
                    }
                    else
                    {
                        // GÜNCELLEME
                        urun = context.Urunler.FirstOrDefault(u => u.UrunID == id);

                        // Koruma: Ürün silinmişse dur
                        if (urun == null)
                        {
                            lblMesaj.Text = "Hata: Ürün bulunamadı.";
                            lblMesaj.CssClass = "alert alert-danger";
                            return;
                        }
                    }

                    // Değerleri Ata
                    urun.UrunAdi = txtUrunAdi.Text;
                    urun.Aciklama = txtAciklama.Text;
                    urun.Aktif = chkAktif.Checked;
                    urun.OneCikan = chkOneCikan.Checked;

                    int stok = 0;
                    int.TryParse(txtStok.Text, out stok);
                    urun.Stok = stok;

                    decimal fiyat = 0;
                    if (!string.IsNullOrEmpty(txtFiyat.Text))
                        decimal.TryParse(txtFiyat.Text.Replace(".", ","), out fiyat);
                    urun.Fiyat = fiyat;

                    // Kategori Kontrolü
                    int katId = 0;
                    if (ddlKategori.SelectedValue != null) int.TryParse(ddlKategori.SelectedValue, out katId);

                    if (katId > 0)
                    {
                        urun.KategoriID = katId;
                    }
                    else
                    {
                        lblMesaj.Text = "Lütfen bir kategori seçiniz!";
                        lblMesaj.CssClass = "alert alert-warning";
                        return; // Kaydetmeden çık
                    }

                    // Resim İşlemleri
                    if (fileResim.HasFile)
                    {
                        string dosyaAdi = Guid.NewGuid().ToString() + Path.GetExtension(fileResim.FileName);
                        string klasor = Server.MapPath("~/img/");
                        if (!Directory.Exists(klasor)) Directory.CreateDirectory(klasor);
                        fileResim.SaveAs(klasor + dosyaAdi);
                        urun.ResimYolu = "img/" + dosyaAdi;
                    }
                    else if (id == 0)
                    {
                        urun.ResimYolu = "https://via.placeholder.com/300";
                    }

                    // Kaydet
                    context.SaveChanges();

                    pnlForm.Visible = false;
                    pnlListe.Visible = true;
                    UrunleriListele();
                    lblMesaj.Text = "";
                }
                catch (Exception ex)
                {
                    string hata = ex.InnerException != null ? ex.InnerException.Message : ex.Message;
                    lblMesaj.Text = "Hata Detayı: " + hata;
                    lblMesaj.CssClass = "alert alert-danger";
                }
            }
        }

        // --- BUTONLAR ---
        protected void btnAra_Click(object sender, EventArgs e) { UrunleriListele(txtAra.Text.Trim()); }
        protected void btnTemizle_Click(object sender, EventArgs e) { txtAra.Text = ""; UrunleriListele(); }
        protected void btnVazgec_Click(object sender, EventArgs e) { pnlForm.Visible = false; pnlListe.Visible = true; }

        protected void btnYeniEkle_Click(object sender, EventArgs e)
        {
            pnlListe.Visible = false;
            pnlForm.Visible = true;
            FormuTemizle();
            lblFormBaslik.Text = "Yeni Ürün Ekle";
            ViewState["IslemID"] = "0";
        }

        private void FormuTemizle()
        {
            txtUrunAdi.Text = "";
            txtAciklama.Text = "";
            txtFiyat.Text = "";
            txtStok.Text = "";
            chkAktif.Checked = true;
            chkOneCikan.Checked = false;
            if (ddlKategori.Items.Count > 0) ddlKategori.SelectedIndex = 0;
            lblMevcutResim.Text = "Yok";
            lblMesaj.Text = "";
        }

        // --- SİLME VE DÜZENLEME ---
        protected void gridUrunler_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "Sil")
            {
                using (var context = new MarketETicaretDBEntities())
                {
                    var silinecek = context.Urunler.Find(id);
                    if (silinecek != null)
                    {
                        try
                        {
                            context.Urunler.Remove(silinecek);
                            context.SaveChanges();
                        }
                        catch
                        {
                            silinecek.Aktif = false;
                            context.SaveChanges();
                        }
                    }
                }
                UrunleriListele();
            }
            else if (e.CommandName == "Duzenle")
            {
                using (var context = new MarketETicaretDBEntities())
                {
                    var urun = context.Urunler.Find(id);
                    if (urun != null)
                    {
                        pnlListe.Visible = false;
                        pnlForm.Visible = true;
                        lblFormBaslik.Text = "Ürün Düzenle";
                        ViewState["IslemID"] = id.ToString();

                        txtUrunAdi.Text = urun.UrunAdi;
                        txtAciklama.Text = urun.Aciklama;
                        txtFiyat.Text = urun.Fiyat.ToString();
                        txtStok.Text = urun.Stok.ToString();
                        chkAktif.Checked = urun.Aktif ?? false;
                        chkOneCikan.Checked = urun.OneCikan ?? false;

                        if (urun.KategoriID > 0) ddlKategori.SelectedValue = urun.KategoriID.ToString();
                        lblMevcutResim.Text = urun.ResimYolu;
                    }
                }
            }
        }
    }
}