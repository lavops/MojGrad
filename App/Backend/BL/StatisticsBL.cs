using Backend.BL.Interfaces;
using Backend.DAL.Interfaces;
using Backend.Models.ViewsModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL
{
    public class StatisticsBL : IStatisticsBL
    {
        private readonly IStatisticsDAL _iStatisticsDAL;

        public StatisticsBL(IStatisticsDAL iStatisticsDAL)
        {
            _iStatisticsDAL = iStatisticsDAL;
        }

        public StatisticsViewModel basicStatistics()
        {
            return _iStatisticsDAL.basicStatistics();
        }
    }
}
