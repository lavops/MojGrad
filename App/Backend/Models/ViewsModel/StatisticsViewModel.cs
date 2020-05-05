using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models.ViewsModel
{
    public class StatisticsViewModel
    {
        public int numberOfPosts { get; set; }
        public int numberOfSolvedPosts { get; set; }
        public int numberOfUnsolvedPosts { get; set; }
        public int numberOfUsers { get; set; }
        public int numberOfInstitutions { get; set; }
        public int numberOfNewPostsIn24h { get; set; }
        public int numberOfNewUsersIn24h { get; set; }
        public int numberOfNewInstitutionIn24h { get; set; }
        public List<int> monthlyUsers { get; set; }
        public List<UserViewModel> top10Users { get; set; }
    }
}
