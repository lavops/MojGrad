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

        public City insertCity(City city)
        {
            City city1 = new City();
            city1.name = city.name;
            city1.latitude = city.latitude;
            city1.longitude = city.longitude;

            if (city1 != null )
            {
                _context.city.Add(city1);
                _context.SaveChangesAsync();
                return city1;
            }
            else
            {
                return null;
            }
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
