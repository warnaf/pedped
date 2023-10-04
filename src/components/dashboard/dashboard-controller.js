import dashboardService from './dashboard-service.js';

const getRecomendationProduct = async (req, res, next) => {
  try {
    const result = await dashboardService.recomendation();
    res.status(200).json({
      isFromRedis: result.isFromRedis,
      data: result.value,
    });
  } catch (error) {
    next(error);
  }
};

const getRecomendationProductRedis = async (req, res, next) => {
  try {
    const result = await dashboardService.recomendationWithRedis();
    res.status(200).json({
      isFromRedis: result.isFromRedis,
      data: result.value,
    });
  } catch (error) {
    next(error);
  }
};

export { getRecomendationProduct, getRecomendationProductRedis };
