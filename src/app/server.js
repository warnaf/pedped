import express from 'express';
import cors from 'cors';
import { errorMiddleware } from '../middleware/error-middleware.js';
import fileUpload from 'express-fileupload';
import orderRouter from '../components/orders/order-route.js';
const app = express();

app.use(
  fileUpload({
    createParentPath: true,
  })
);
app.use(express.static('public'));
app.use(express.json());
app.use(cors());

// route component
app.use('/api/order', orderRouter.router);

app.use(errorMiddleware);
export { app };
