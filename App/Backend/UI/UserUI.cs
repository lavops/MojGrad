using Backend.BL.Interfaces;
using Backend.Models;
using Backend.UI.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.UI
{
    public class UserUI :IUserUI
    {
        private readonly IUserBL _iUserBL;

        public UserUI(IUserBL iUserBL)
        {
            _iUserBL = iUserBL;
        }
        public List<User> getAllUsers()
        {
            return _iUserBL.getAllUsers();
        }

        public User getByID(long id)
        {
            return _iUserBL.getByID(id);
        }

        public User insertUser(User user)
        {
            return _iUserBL.insertUser(user);
        }

        public User login(User user)
        {
            return _iUserBL.login(user);
        }
    }
}
