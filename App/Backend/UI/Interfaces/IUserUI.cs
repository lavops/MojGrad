using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.UI.Interfaces
{
    public interface IUserUI
    {
        List<User> getAllUsers();
        User getByID(long id);
        User insertUser(User user);
        User login(User user);
    }
}
