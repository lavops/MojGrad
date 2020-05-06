using Backend.Models.ViewsModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.UI.Interfaces
{
    public interface IStatisticsUI
    {
        StatisticsViewModel basicStatistics();
    }
}
