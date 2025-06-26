-- CreateTable
CREATE TABLE "employees" (
    "employeeid" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "phone_number" VARCHAR(20),
    "email" VARCHAR(100) NOT NULL,
    "pwd" VARCHAR(255) NOT NULL,
    "role" VARCHAR(50) NOT NULL,

    CONSTRAINT "employees_pkey" PRIMARY KEY ("employeeid")
);

-- CreateTable
CREATE TABLE "patients" (
    "patientid" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "age" INTEGER NOT NULL,
    "gender" VARCHAR(10) NOT NULL,
    "phone_number" VARCHAR(20),

    CONSTRAINT "patients_pkey" PRIMARY KEY ("patientid")
);

-- CreateTable
CREATE TABLE "prescribe" (
    "id" SERIAL NOT NULL,
    "employeeid" INTEGER NOT NULL,
    "patientid" INTEGER NOT NULL,

    CONSTRAINT "prescribe_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "reports" (
    "reportid" SERIAL NOT NULL,
    "patientid" INTEGER,
    "type" VARCHAR(100) NOT NULL,
    "date_uploaded" TIMESTAMP(3),

    CONSTRAINT "reports_pkey" PRIMARY KEY ("reportid")
);

-- AddForeignKey
ALTER TABLE "prescribe" ADD CONSTRAINT "prescribe_employeeid_fkey" FOREIGN KEY ("employeeid") REFERENCES "employees"("employeeid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "prescribe" ADD CONSTRAINT "prescribe_patientid_fkey" FOREIGN KEY ("patientid") REFERENCES "patients"("patientid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reports" ADD CONSTRAINT "reports_patientid_fkey" FOREIGN KEY ("patientid") REFERENCES "patients"("patientid") ON DELETE SET NULL ON UPDATE CASCADE;
