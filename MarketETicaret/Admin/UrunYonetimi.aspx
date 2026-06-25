<%@ Page Title="Ürün Yönetimi" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeBehind="UrunYonetimi.aspx.cs" Inherits="MarketETicaret.Admin.UrunYonetimi" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <asp:Panel ID="pnlListe" runat="server">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-gray-800"><i class="fas fa-boxes me-2"></i>Ürün Yönetimi</h2>
            <asp:Button ID="btnYeniEkle" runat="server" Text="+ Yeni Ürün Ekle" CssClass="btn btn-success shadow-sm" OnClick="btnYeniEkle_Click" />
        </div>

        <div class="card shadow mb-4 border-left-primary">
            <div class="card-body">
                <div class="row">
                    <div class="col-md-8">
                        <div class="input-group">
                            <span class="input-group-text bg-white border-end-0"><i class="fas fa-search text-muted"></i></span>
                            <asp:TextBox ID="txtAra" runat="server" CssClass="form-control border-start-0" placeholder="Ürün adı ile arama yap..."></asp:TextBox>
                            <asp:Button ID="btnAra" runat="server" Text="Ara" CssClass="btn btn-primary" OnClick="btnAra_Click" />
                        </div>
                    </div>
                    <div class="col-md-4 text-end">
                        <asp:Button ID="btnTemizle" runat="server" Text="Listeyi Sıfırla" CssClass="btn btn-secondary" OnClick="btnTemizle_Click" />
                    </div>
                </div>
            </div>
        </div>

        <div class="card shadow">
            <div class="card-body table-responsive">
                <asp:GridView ID="gridUrunler" runat="server" AutoGenerateColumns="False" 
                    CssClass="table table-bordered table-hover align-middle" 
                    DataKeyNames="UrunID" OnRowCommand="gridUrunler_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="UrunID" HeaderText="ID" ItemStyle-Width="50px" />
                        
                        <asp:TemplateField HeaderText="Resim">
                            <ItemTemplate>
                                <img src='<%# Eval("ResimYolu").ToString().Replace("~","..") %>' width="50" height="50" style="object-fit:contain; border:1px solid #ddd; padding:2px; border-radius:5px;" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        
                        <asp:BoundField DataField="UrunAdi" HeaderText="Ürün Adı" />
                        <asp:BoundField DataField="KategoriAdi" HeaderText="Kategori" />
                        <asp:BoundField DataField="Fiyat" HeaderText="Fiyat" DataFormatString="{0:C}" />
                        
                        <asp:TemplateField HeaderText="Stok">
                            <ItemTemplate>
                                <span class='badge bg-<%# Convert.ToInt32(Eval("Stok")) < 5 ? "danger" : "success" %>'>
                                    <%# Eval("Stok") %> Adet
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        
                        <%-- ÖNE ÇIKAN HIZLI SEÇİM --%>
                        <asp:TemplateField HeaderText="Öne Çıkan" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <div class="form-check form-switch d-flex justify-content-center">
                                    <%-- ToolTip içine ID gizliyoruz, kod tarafında buradan okuyacağız --%>
                                    <asp:CheckBox ID="chkGridOneCikan" runat="server" 
                                        Checked='<%# Eval("OneCikan") != null && (bool)Eval("OneCikan") %>' 
                                        AutoPostBack="true" 
                                        OnCheckedChanged="chkGridOneCikan_CheckedChanged"
                                        ToolTip='<%# Eval("UrunID") %>' 
                                        CssClass="form-check-input" style="cursor:pointer;" />
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Durum">
                            <ItemTemplate>
                                <%# Convert.ToBoolean(Eval("Aktif")) ? "<span class='text-success'>Yayında</span>" : "<span class='text-muted'>Pasif</span>" %>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="İşlemler" ItemStyle-Width="160px" ItemStyle-CssClass="text-center">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnDuzenle" runat="server" CommandName="Duzenle" CommandArgument='<%# Eval("UrunID") %>' CssClass="btn btn-primary btn-sm me-1"><i class="fas fa-edit"></i></asp:LinkButton>
                                <asp:LinkButton ID="btnSil" runat="server" CommandName="Sil" CommandArgument='<%# Eval("UrunID") %>' CssClass="btn btn-danger btn-sm" OnClientClick="return confirm('Silinsin mi?');"><i class="fas fa-trash"></i></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="text-center p-4 text-muted">Kayıt bulunamadı.</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>
    </asp:Panel>

    <asp:Panel ID="pnlForm" runat="server" Visible="false">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card shadow border-top-primary">
                    <div class="card-header bg-white py-3">
                        <h5 class="m-0 font-weight-bold text-primary">
                            <asp:Label ID="lblFormBaslik" runat="server" Text="Ürün Ekle / Düzenle"></asp:Label>
                        </h5>
                    </div>
                    <div class="card-body">
                        <asp:Label ID="lblMesaj" runat="server" CssClass="d-block mb-3"></asp:Label>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Ürün Adı</label>
                            <asp:TextBox ID="txtUrunAdi" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Kategori</label>
                                <asp:DropDownList ID="ddlKategori" runat="server" CssClass="form-select"></asp:DropDownList>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Fiyat (₺)</label>
                                <asp:TextBox ID="txtFiyat" runat="server" CssClass="form-control" TextMode="Number" step="0.01"></asp:TextBox>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Stok</label>
                                <asp:TextBox ID="txtStok" runat="server" CssClass="form-control" TextMode="Number"></asp:TextBox>
                            </div>
                            
                            <%-- SEÇENEKLER --%>
                            <div class="col-md-6 mb-3 d-flex align-items-end flex-column justify-content-end">
                                <div class="form-check form-switch p-2 border rounded w-100 bg-light mb-2">
                                    <asp:CheckBox ID="chkAktif" runat="server" CssClass="form-check-input ms-0 me-2" Checked="true" />
                                    <label class="form-check-label ms-4">Ürün Sitede Görünsün</label>
                                </div>
                                
                                <div class="form-check form-switch p-2 border rounded w-100 bg-light">
                                    <asp:CheckBox ID="chkOneCikan" runat="server" CssClass="form-check-input ms-0 me-2" />
                                    <label class="form-check-label ms-4 fw-bold text-primary">★ Öne Çıkan Ürün</label>
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Açıklama</label>
                            <asp:TextBox ID="txtAciklama" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4"></asp:TextBox>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-bold">Resim</label>
                            <div class="mb-2">
                                <img id="imgOnizleme" src="" style="max-width: 200px; max-height: 200px; border: 1px solid #ddd; padding: 5px; border-radius: 5px; display:none;" />
                            </div>
                            <asp:FileUpload ID="fileResim" runat="server" CssClass="form-control" onchange="ResimGoster(this);" />
                            <div class="mt-2"><small class="text-muted">Mevcut:</small> <asp:Label ID="lblMevcutResim" runat="server" Text="Yok" CssClass="fw-bold"></asp:Label></div>
                        </div>

                        <div class="d-flex justify-content-end border-top pt-3">
                            <asp:Button ID="btnVazgec" runat="server" Text="Vazgeç" CssClass="btn btn-secondary me-2" OnClick="btnVazgec_Click" CausesValidation="false" />
                            <asp:Button ID="btnKaydet" runat="server" Text="Kaydet" CssClass="btn btn-success px-4" OnClick="btnKaydet_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </asp:Panel>

    <script type="text/javascript">
        function ResimGoster(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    var img = document.getElementById('imgOnizleme');
                    img.src = e.target.result;
                    img.style.display = 'block';
                };
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>

</asp:Content>