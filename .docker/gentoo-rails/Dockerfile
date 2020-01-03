FROM gentoo/portage:latest as portage
FROM gentoo/stage3-amd64

# Need a portage tree to build, use last nights.
COPY --from=portage /var/db/repos/gentoo /var/db/repos/gentoo

# Sandbox doesn't work well in docker.
ENV FEATURES="-userpriv -usersandbox -sandbox"
ENV USE="-bindist"

RUN emerge -C openssh
RUN emerge net-libs/nodejs
RUN emerge sys-process/cronie
# Bundler is how we install the ruby stuff.
RUN mkdir -p /etc/portage/package.accept_keywords/
RUN echo "dev-ruby/rdoc ~amd64" >> /etc/portage/package.accept_keywords/ruby
RUN echo "dev-lang/ruby ~amd64" >> /etc/portage/package.accept_keywords/ruby

RUN emerge =dev-lang/ruby-2.5.7

RUN eselect ruby set ruby25

RUN gem install bundler -v 1.17.3

RUN emerge dev-vcs/git

RUN echo "sys-apps/yarn ~amd64" >> /etc/portage/package.accept_keywords/yarn
RUN emerge sys-apps/yarn
RUN ln -s /usr/lib64/node_modules/yarn/bin/yarnpkg /usr/bin/yarnpkg