using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace SchoolSystemIndividual.Models;

public partial class SchoolSystemDbContext : DbContext
{
    public SchoolSystemDbContext()
    {
    }

    public SchoolSystemDbContext(DbContextOptions<SchoolSystemDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Class> Classes { get; set; }

    public virtual DbSet<Course> Courses { get; set; }

    public virtual DbSet<Department> Departments { get; set; }

    public virtual DbSet<Employee> Employees { get; set; }

    public virtual DbSet<Grade> Grades { get; set; }

    public virtual DbSet<Student> Students { get; set; }

    public virtual DbSet<User> Users { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Server=(localdb)\\MSSQLLocalDB;Database=SchoolSystemDB;Trusted_Connection=True;");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Class>(entity =>
        {
            entity.HasKey(e => e.ClassId).HasName("PK__Classes__CB1927A08E0FCF14");

            entity.Property(e => e.ClassId).HasColumnName("ClassID");
            entity.Property(e => e.ClassName).HasMaxLength(50);
        });

        modelBuilder.Entity<Course>(entity =>
        {
            entity.HasKey(e => e.CourseId).HasName("PK__Courses__C92D7187F36CB0E6");

            entity.Property(e => e.CourseId).HasColumnName("CourseID");
            entity.Property(e => e.CourseName).HasMaxLength(100);
            entity.Property(e => e.IsActive).HasDefaultValue(true);
        });

        modelBuilder.Entity<Department>(entity =>
        {
            entity.HasKey(e => e.DepartmentId).HasName("PK__Departme__B2079BCD2DE28C3D");

            entity.Property(e => e.DepartmentId).HasColumnName("DepartmentID");
            entity.Property(e => e.Budget).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.DepartmentName).HasMaxLength(100);
        });

        modelBuilder.Entity<Employee>(entity =>
        {
            entity.HasKey(e => e.EmployeeId).HasName("PK__Employee__7AD04FF1731DEE58");

            entity.HasIndex(e => e.EmployeeNumber, "UQ__Employee__8D6635987295ADD3").IsUnique();

            entity.Property(e => e.EmployeeId).HasColumnName("EmployeeID");
            entity.Property(e => e.ClassId).HasColumnName("ClassID");
            entity.Property(e => e.DepartmentId).HasColumnName("DepartmentID");
            entity.Property(e => e.EmployeeName).HasMaxLength(100);
            entity.Property(e => e.Position).HasMaxLength(50);

            entity.HasOne(d => d.Class).WithMany(p => p.Employees)
                .HasForeignKey(d => d.ClassId)
                .HasConstraintName("FK__Employees__Class__403A8C7D");

            entity.HasOne(d => d.Department).WithMany(p => p.Employees)
                .HasForeignKey(d => d.DepartmentId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Employees__Depar__3F466844");
        });

        modelBuilder.Entity<Grade>(entity =>
        {
            entity.HasKey(e => e.GradeId).HasName("PK__Grades__54F87A37451E13D9");

            entity.Property(e => e.GradeId).HasColumnName("GradeID");
            entity.Property(e => e.ClassId).HasColumnName("ClassID");
            entity.Property(e => e.CourseId).HasColumnName("CourseID");
            entity.Property(e => e.EmployeeId).HasColumnName("EmployeeID");
            entity.Property(e => e.Grade1)
                .HasMaxLength(2)
                .HasColumnName("Grade");
            entity.Property(e => e.StudentId).HasColumnName("StudentID");

            entity.HasOne(d => d.Class).WithMany(p => p.Grades)
                .HasForeignKey(d => d.ClassId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Grades__ClassID__48CFD27E");

            entity.HasOne(d => d.Course).WithMany(p => p.Grades)
                .HasForeignKey(d => d.CourseId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Grades__CourseID__46E78A0C");

            entity.HasOne(d => d.Employee).WithMany(p => p.Grades)
                .HasForeignKey(d => d.EmployeeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Grades__Employee__47DBAE45");

            entity.HasOne(d => d.Student).WithMany(p => p.Grades)
                .HasForeignKey(d => d.StudentId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Grades__StudentI__45F365D3");
        });

        modelBuilder.Entity<Student>(entity =>
        {
            entity.HasKey(e => e.StudentId).HasName("PK__Students__32C52A7967A83FF6");

            entity.HasIndex(e => e.StudentNumber, "UQ__Students__DD81BF6CD6855D48").IsUnique();

            entity.Property(e => e.StudentId).HasColumnName("StudentID");
            entity.Property(e => e.ClassId).HasColumnName("ClassID");
            entity.Property(e => e.FirstName).HasMaxLength(50);
            entity.Property(e => e.LastName).HasMaxLength(50);

            entity.HasOne(d => d.Class).WithMany(p => p.Students)
                .HasForeignKey(d => d.ClassId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Students__ClassI__398D8EEE");
        });

        modelBuilder.Entity<User>(entity =>
        {
            entity.HasKey(e => e.UserId).HasName("PK__Users__1788CCACD170B886");

            entity.HasIndex(e => e.Username, "UQ__Users__536C85E4259B54FC").IsUnique();

            entity.Property(e => e.UserId).HasColumnName("UserID");
            entity.Property(e => e.CreatedDate)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Email).HasMaxLength(100);
            entity.Property(e => e.FullName).HasMaxLength(100);
            entity.Property(e => e.Password).HasMaxLength(255);
            entity.Property(e => e.UserType).HasMaxLength(20);
            entity.Property(e => e.Username).HasMaxLength(50);
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
