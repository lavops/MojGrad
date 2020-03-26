using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class UserType
    {
        public long id { get; set; }
        public string typeName { get; set; }

        public IList<user> users { get; set; }
    }
}
