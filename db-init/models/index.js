const { Sequelize, DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  const Employee = sequelize.define('employees', {
    employeeid: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    name: {
      type: DataTypes.STRING(100),
      allowNull: false
    },
    phone_number: {
      type: DataTypes.STRING(20),
      allowNull: true
    },
    email: {
      type: DataTypes.STRING(100),
      allowNull: false
    },
    pwd: {
      type: DataTypes.STRING(255),
      allowNull: false
    },
    role: {
      type: DataTypes.STRING(50),
      allowNull: false
    }
  }, {
    timestamps: false,
    underscored: true
  });

  const Patient = sequelize.define('patients', {
    patientid: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    name: {
      type: DataTypes.STRING(100),
      allowNull: false
    },
    age: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    gender: {
      type: DataTypes.STRING(10),
      allowNull: false
    },
    phone_number: {
      type: DataTypes.STRING(20),
      allowNull: true
    }
  }, {
    timestamps: false,
    underscored: true
  });

  const Prescribe = sequelize.define('prescribe', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    employeeid: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: { model: Employee, key: 'employeeid' }
    },
    patientid: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: { model: Patient, key: 'patientid' }
    }
  }, {
    timestamps: false,
    underscored: true
  });

  const Report = sequelize.define('reports', {
    reportid: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    patientid: {
      type: DataTypes.INTEGER,
      allowNull: true,
      references: { model: Patient, key: 'patientid' }
    },
    type: {
      type: DataTypes.STRING(100),
      allowNull: false,
      field: 'type'
    },
    date_uploaded: {
      type: DataTypes.DATE,
      allowNull: true
    }
  }, {
    timestamps: false,
    underscored: true
  });

  // set up associations (optional, but good practice)
  Employee.hasMany(Prescribe, { foreignKey: 'employeeid' });
  Patient.hasMany(Prescribe,  { foreignKey: 'patientid' });
  Patient.hasMany(Report,     { foreignKey: 'patientid' });
  Prescribe.belongsTo(Employee, { foreignKey: 'employeeid' });
  Prescribe.belongsTo(Patient,  { foreignKey: 'patientid' });
  Report.belongsTo(Patient,     { foreignKey: 'patientid' });

  return { Employee, Patient, Prescribe, Report };
};
