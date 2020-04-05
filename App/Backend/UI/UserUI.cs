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

        public bool deleteUser(long id)
        {
            return _iUserBL.deleteUser(id);
        }

        public User editUserData(User user)
        {
            return _iUserBL.editUserData(user);
        }

        public User editUserPassword(long id, string password, string newPassword)
        {
            return _iUserBL.editUserPassword(id, password, newPassword);
        }

        public User editUserPhoto(long id, string photoPathn)
        {
            return _iUserBL.editUserPhoto(id, photoPathn);
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
