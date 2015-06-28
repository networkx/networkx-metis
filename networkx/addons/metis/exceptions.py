__all__ = ['MetisError']

class MetisError(Exception):
    """Error returned by METIS"""

    def __init__(self, rstatus):
        """Types of return codes.

            ======================================== ==================
            Returned normally                        METIS_OK
            Returned due to erroneous inputs/options METIS_ERROR_INPUT
            Returned due to insufficient memory      METIS_ERROR_MEMORY
            Some other errors                        METIS_ERROR
            ======================================== ==================
        """
        super(MetisError, self).__init__(rstatus)
