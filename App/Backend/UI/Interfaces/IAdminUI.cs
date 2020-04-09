using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.UI.Interfaces
{
    public interface IAdminUI
    {
        List<Admin> getAllAdmins();
        Admin getByID(long id);
        Admin insertAdmin(Admin admin);
        string login(Admin admin);
        Admin editAdminData(Admin admin);
        Admin editAdminPassword(long id, string password, string newPassword);
        bool deleteAdmin(long id);
    }
}
