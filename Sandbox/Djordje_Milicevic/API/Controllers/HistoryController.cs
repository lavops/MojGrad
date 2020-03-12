using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using API.Data;
using API.Helpers;
using API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;

namespace API.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class HistoryController : ControllerBase
    {
        private bazaContext contex = new bazaContext();
        private readonly AppSettings _appSettings;

        public HistoryController(IOptions<AppSettings> appSettings)
        {
            _appSettings = appSettings.Value;
        }

        [HttpGet("Count/{id}")]
        public int CountHistory(int id)
        {
            int broj = contex.Histories.Where(x => x.user.idUser == id).Count();
            return broj;
        }

        [HttpGet("Last/{id}")]
        public IActionResult LastLogin(int id)
        {
            var lastTime = contex.Histories.Where(x => x.user.idUser == id).OrderByDescending(x => x.id).FirstOrDefault();
            lastTime.user = null;
            return Ok(lastTime);
        }
    }
}
