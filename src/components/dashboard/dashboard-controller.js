import dashboardService from './dashboard-service.js';

const getRecomendationProduct = async (req, res, next) => {
  try {
    const result = await dashboardService.recomendation();
    res.status(200).json({
      data: result,
    });
  } catch (error) {
    next(error);
  }
};

const getRecomendationProductRedis = async (req, res, next) => {
  try {
    const result = await dashboardService.recomendation();
    res.status(200).json({
      data: result,
    });
  } catch (error) {
    next(error);
  }
};

export { getRecomendationProduct, getRecomendationProductRedis };
