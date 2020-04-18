using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models.ViewsModel
{
    public class DonationViewModel
    {
        public long id { get; set; }
        public long adminId { get; set; }
        public string title { get; set; }
        public string organizationName { get; set; }
        public string description { get; set; }
        public double monetaryAmount { get; set; }
        public double collectedMoney { get; set; }
        public int userNum { get; set; }
        private AppDbContext _context = new AppDbContext();
        public DonationViewModel(Donation don)
        {
            this.id = don.id;
            this.adminId = don.adminId;
            this.collectedMoney = don.collectedMoney;
            this.description = don.description;
            this.monetaryAmount = don.monetaryAmount;
            this.organizationName = don.organizationName;
            this.title = don.title;
            this.userNum = _context.userDonation.Where(x => x.donationId == don.id).Count();

        }
    }
}
