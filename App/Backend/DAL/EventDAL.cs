using Backend.DAL.Interfaces;
using Backend.Models;
using Backend.Models.ViewsModel;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using static Backend.Controllers.EventController;

namespace Backend.DAL
{
    public class EventDAL : IEventDAL
    {
        private readonly AppDbContext _context;

        public EventDAL(AppDbContext context)
        {
            _context = context;
        }

        public bool addGoingToEvent(UserEvent ue)
        {
            UserEvent eve = new UserEvent();
            eve.userId = ue.userId;
            eve.eventId = ue.eventId;
            
            if (eve != null)
            {
                _context.userEvent.Add(eve);
                _context.SaveChangesAsync();
                return true;
            }
            else
            {
                return false;
            }
        }

        public bool cancelArrival(UserEvent ue)
        {
            var events = _context.userEvent.Where(x => x.userId == ue.userId && x.eventId == ue.eventId).FirstOrDefault();
            if (events == null)
            {
                return false;
            }

            _context.userEvent.Remove(events);
            _context.SaveChangesAsync();

            return true;
        }

        public bool deleteEvent(long id)
        {
            var events = _context.events.Where(x => x.id == id).FirstOrDefault();
            if (events == null)
            {
                return false;
            }

            _context.events.Remove(events);
            _context.SaveChangesAsync();

            return true;
        }

        public Event editEvent(EventViewModel events)
        {
            var exist = _context.events.Where(x => x.id == events.id).FirstOrDefault();
            if (exist != null)
            {
                try
                {

                    exist.description = events.description;
                    exist.startDate = DateTime.Parse(events.startDate);
                    exist.endDate = DateTime.Parse(events.endDate);
                    exist.shortDescription = events.shortDescription;
                    exist.title = events.title;
                    _context.Update(exist);
                    _context.SaveChanges();
                    return _context.events.Where((u) => u.id == events.id).Include(x => x.institution).Include(l => l.admin).Include(c=> c.city).FirstOrDefault();
                }
                catch (DbUpdateException ex)
                {
                    Console.WriteLine(ex.Message);
                }

            }
            return null;
        }

        public List<Event> getAllEvents()
        {
            return _context.events.Where(x => x.endDate > DateTime.Now).Include(x => x.institution).Include(l => l.admin).Include(c => c.city).ToList();
        }

        public List<Event> getAllEventsByCityId(long id)
        {
            return _context.events.Where(x => x.endDate > DateTime.Now && x.cityId == id).Include(x => x.institution).Include(l => l.admin).Include(c => c.city).ToList();
        }

        public Event getByID(long id)
        {
            return _context.events.Where(x => x.id == id).Include(x => x.institution).Include(l => l.admin).Include(c => c.city).FirstOrDefault();
        }

        public Event insertEvent(EventViewModel events)
        {
            Event eve = new Event();

            eve.cityId = events.cityId;
            eve.adminId = events.adminId;
            eve.institutionId = events.institutionId;
            eve.latitude = events.latitude;
            eve.longitude = eve.longitude;
            eve.shortDescription = eve.shortDescription;
            eve.startDate = DateTime.Parse(events.startDate);
            eve.endDate = DateTime.Parse(events.endDate);
            eve.address = events.address;
            eve.description = events.description;
            eve.title = events.title;
            if (eve != null)
            {
                _context.events.Add(eve);
                _context.SaveChangesAsync();
                return eve;
            }
            else
            {
                return null;
            }
        }

        public List<UserEvent> usersGoingToEvent(long eventId)
        {
            return _context.userEvent.Where(x => x.eventId == eventId).Include(u => u.user).ToList();
        }
    }
}
