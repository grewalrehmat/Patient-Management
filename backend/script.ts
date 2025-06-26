import { PrismaClient } from './generated/prisma/client.js';

const prisma = new PrismaClient();

// use `prisma` in your application to read and write data in your DB

async function main() {
  const patient = await prisma.patient.create({
    data: {
      name: 'John Doe',
      age: 30,
      gender: 'Male',
      phone_number: '1234567890',
    },
  });

  console.log('Patient created:', patient);
}

// main()
//   .then(async () => {
//     await prisma.$disconnect()
//   })
//   .catch(async (e) => {
//     console.error(e)
//     await prisma.$disconnect()
//     process.exit(1)
//   })