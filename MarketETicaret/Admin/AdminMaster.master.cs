using System;
using System.Web.UI;
namespace MarketETicaret.Admin
{
    public partial class AdminMaster : System.Web.UI.MasterPage
    {
        protected void btnCikis_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            Response.Redirect("~/Default.aspx");
        }
    }
}