var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
import { PrismaClient } from './generated/prisma/client.js';
const prisma = new PrismaClient();
// use `prisma` in your application to read and write data in your DB
function main() {
    return __awaiter(this, void 0, void 0, function* () {
        const patient = yield prisma.patient.create({
            data: {
                name: 'John Doe',
                age: 30,
                gender: 'Male',
                phone_number: '1234567890',
            },
        });
        console.log('Patient created:', patient);
    });
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
