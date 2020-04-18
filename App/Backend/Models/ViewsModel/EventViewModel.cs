using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models.ViewsModel
{
    public class EventViewModel
    {
        public long id { get; set; }
        public long? institutionId { get; set; }
        public long? adminId { get; set; }
        public string organizeName { get; set; }
        public long cityId { get; set; }
        public string cityName { get; set; }
        public string startDate { get; set; }
        public string endDate { get; set; }
        public string shortDescription { get; set; }
        public double latitude { get; set; }
        public double longitude { get; set; }
        public string address { get; set; }
        public string title { get; set; }
        public string description { get; set; }
        public int userNum { get; set; }
        public int isGoing { get; set; }
        private AppDbContext _context = new AppDbContext();
        public EventViewModel() { }
        public EventViewModel(Event e, long? userId)
        {
            this.id = e.id;
            this.cityId = e.cityId;
            this.cityName = e.city.name;
            this.institutionId = e.institutionId;
            if (e.institution == null)
            {
                this.organizeName = e.admin.firstName +" " + e.admin.lastName;
            }
            else
            {
                this.organizeName = e.institution.name;
            }
            this.startDate = e.startDate.ToString("dd/MM/yyyy hh:mm");
            this.endDate = e.endDate.ToString("dd/MM/yyyy hh:mm");
            this.address = e.address;
            this.description = e.description;
            this.latitude = e.latitude;
            this.longitude = e.longitude;
            this.shortDescription = e.shortDescription;
            this.title = e.title;
            this.userNum = _context.userEvent.Where(x => x.eventId == e.id).Count();
            if (userId != null)
            {
                var user = _context.userEvent.Where(x => x.eventId == e.id && x.userId == userId).FirstOrDefault();
                if (user != null)
                    this.isGoing = 1;
            }
            else
                this.isGoing = 0;
        }
    }
}
