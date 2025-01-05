using System;
using System.Collections.Generic;

namespace SchoolSystemIndividual.Models;

public partial class Employee
{
    public int EmployeeId { get; set; }

    public string EmployeeName { get; set; } = null!;

    public string Position { get; set; } = null!;

    public int EmployeeNumber { get; set; }

    public DateOnly StartDate { get; set; }

    public double MonthlySalary { get; set; }

    public int DepartmentId { get; set; }

    public int? ClassId { get; set; }

    public virtual Class? Class { get; set; }

    public virtual Department Department { get; set; } = null!;

    public virtual ICollection<Grade> Grades { get; set; } = new List<Grade>();
}
