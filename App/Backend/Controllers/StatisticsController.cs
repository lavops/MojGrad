using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Backend.Models.ViewsModel;
using Backend.UI.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class StatisticsController : ControllerBase
    {
        private readonly IStatisticsUI _iStatisticsUI;

        public StatisticsController(IStatisticsUI iStatisticsUI)
        {
            _iStatisticsUI = iStatisticsUI;
        }

        [Authorize]
        [HttpGet]
        public StatisticsViewModel GetStatistics()
        {
            return _iStatisticsUI.basicStatistics();
        }
    }
}