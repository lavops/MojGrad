using Backend.DAL.Interfaces;
using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL
{
    public class CityDAL : ICityDAL
    {
        private readonly AppDbContext _context;

        public CityDAL(AppDbContext context)
        {
            _context = context;
        }

        public List<City> getAllCities()
        {
            return _context.city.ToList();
        }

        public City getByID(long id)
        {
            return _context.city.Where(c => c.id == id).FirstOrDefault();
        }
    }
}
