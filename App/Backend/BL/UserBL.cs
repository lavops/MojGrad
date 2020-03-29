using Backend.BL.Interfaces;
using Backend.DAL.Interfaces;
using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL
{
    public class UserBL : IUserBL
    {
        private readonly IUserDAL _iUserDAL;

        public UserBL(IUserDAL iUserDAL)
        {
            _iUserDAL = iUserDAL;
        }
        public List<User> getAllUsers()
        {
            return _iUserDAL.getAllUsers();
        }

        public User getByID(long id)
        {
            return _iUserDAL.getByID(id);
        }

        public User insertUser(User user)
        {
            return _iUserDAL.insertUser(user);
        }

        public User login(User user)
        {
            return _iUserDAL.login(user);
        }
    }
}
