module EpicenterHelper

	def number_of_followers(user)
		followers = 0
		
		User.all.each do |x|
			if x.following.include?(user.id)
				followers += 1
			end
		end

		return followers
	end

end
