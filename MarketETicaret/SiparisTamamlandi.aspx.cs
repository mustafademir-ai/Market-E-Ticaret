using System;
using System.Web.UI;

namespace MarketETicaret
{
    public partial class SiparisTamamlandi : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Kullanıcı bu sayfaya sadece sipariş verdikten sonra gelmeli.
            // Ama şimdilik bir kısıtlama koymuyoruz, herkes görebilir.
        }
    }
}