using Backend.DAL.Interfaces;
using Backend.Models;
using Backend.Models.ViewsModel;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL
{
    public class ReportDAL : IReportDAL
    {
        private readonly AppDbContext _context;

        public ReportDAL(AppDbContext context)
        {
            _context = context;
        }

        public List<User> getAllReportedUser()
        {
           return _context.user.Include(x => x.city).Include(s => s.userTypes).Include(p => p.posts).ToList();
           
        }

        public List<Report> getAllUserWhoHaveReportedUser(long id)
        {
            return _context.report.Where(x => x.reportedUserId == id).Include(r=>r.reportType).Include(u=>u.reportingUser).ToList();
        }

        public Report insertReport(Report report)
        {
            Report report1 = new Report();

            report1.reportedUserId = report.reportedUserId;
            report1.reportingUserId = report.reportingUserId;
            report1.reportTypeId = report.reportTypeId;
            report1.time = DateTime.Now;


            if (report1 != null)
            {
                _context.report.Add(report1);
                _context.SaveChangesAsync();
                return report1;
            }
            else
            {
                return null;
            }
        }
    }
}
