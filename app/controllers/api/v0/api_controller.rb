module Api
  module V0
    class ApiController < ActionController::Base

      protected

      def pagination_options(scope)
        {
          total: scope.total_count,
          pages: scope.total_pages,
          current_page: scope.current_page,
          next_page: scope.next_page,
          prev_page: scope.prev_page,
          per_page: scope.limit_value
        }
      end
    end
  end
end
