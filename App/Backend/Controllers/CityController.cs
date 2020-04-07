using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Backend.Models;
using Backend.UI.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CityController : ControllerBase
    {
        private readonly ICityUI _iCityUI;

        public CityController(ICityUI iCityUI)
        {
            _iCityUI = iCityUI;
        }

        [Authorize]
        [HttpGet]
        public ActionResult<IEnumerable<City>> GetCity()
        {
            return  _iCityUI.getAllCities();
        }

     }
}