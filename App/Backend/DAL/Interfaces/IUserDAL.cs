using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL.Interfaces
{
    public interface IUserDAL
    {
        List<User> getAllUsers();
        User getByID(long id);
        User insertUser(User user);
        User login(User user);
        User editUserData(User user);
        User editUserPassword(long id, string password, string newPassword);
        bool deleteUser(long id);

    }
}
