<template>
  <div
    id="demo-pull-header-footer"
    specital-attr="pull-header-footer"
  >
    <div class="toolbar">
      <button
        class="toolbar-btn"
        @click="scrollToNextPage"
      >
        <span>{{ n % 2 !== 0 ? '34786125' : '12345'}}</span>
      </button>
    </div>
    <ul
      id="list"
      ref="list"
      :numberOfRows="dataSource.length"
    >
      /**
      * 下拉组件
      *
      * 事件：
      *   idle: 滑动距离在 pull-header 区域内触发一次，参数 contentOffset，滑动距离
      *   pulling: 滑动距离超出 pull-header 后触发一次，参数 contentOffset，滑动距离
      *   refresh: 滑动超出距离，松手后触发一次
      */
      /**
      * 上拉组件
      *   > 如果不需要显示加载情况，可以直接使用 ul 的 onEndReached 实现一直加载
      *
      * 事件：
      *   idle: 滑动距离在 pull-footer 区域内触发一次，参数 contentOffset，滑动距离
      *   pulling: 滑动距离超出 pull-footer 后触发一次，参数 contentOffset，滑动距离
      *   released: 滑动超出距离，松手后触发一次
      */
      <li
          v-for="(ui, index) in dataSource"
          :key="ui.itemBean.title"
          class="item-style"
          :type="'row-' + ui.style"
      >
        <style-one
            v-if="ui.style === 1"
            :item-bean="ui.itemBean"
        />
        <style-two
            v-if="ui.style === 2"
            :item-bean="ui.itemBean"
        />
        <style-five
            v-if="ui.style === 5"
            :item-bean="ui.itemBean"
        />
      </li>
      /**
      * 上拉组件
      *   > 如果不需要显示加载情况，可以直接使用 ul 的 onEndReached 实现一直加载
      *
      * 事件：
      *   idle: 滑动距离在 pull-footer 区域内触发一次，参数 contentOffset，滑动距离
      *   pulling: 滑动距离超出 pull-footer 后触发一次，参数 contentOffset，滑动距离
      *   released: 滑动超出距离，松手后触发一次
      */
    </ul>
  </div>
</template>

<script>
import Vue from 'vue';

import '../list-items';

const MOCK_IMG = 'https://user-images.githubusercontent.com/12878546/148736841-59ce5d1c-8010-46dc-8632-01c380159237.jpg';
const MOCK_IMG2 = 'https://user-images.githubusercontent.com/12878546/148736850-4fc13304-25d4-4b6a-ada3-cbf0745666f5.jpg';
const MOCK_COVER = 'https://user-images.githubusercontent.com/12878546/148736859-29e3a5b2-612a-4fdd-ad21-dc5d29fa538f.jpg';

const STYLE_1 = {
  style: 1,
  itemBean: {
    title: '1- 111111111111111',
    picList: [MOCK_IMG, MOCK_IMG, MOCK_IMG],
    subInfo: ['三图评论', '11评'],
  },
};
const STYLE_2 = {
  style: 2,
  itemBean: {
    title: '2 - 222222222222222',
    picUrl: MOCK_IMG2,
    subInfo: ['左文右图'],
  },
};
const STYLE_3 = {
  style: 5,
  itemBean: {
    title: '3 - 3333333333',
    picUrl: MOCK_COVER,
    subInfo: ['六眼神魔  5234播放'],
  },
};
const STYLE_4 = {
  style: 1,
  itemBean: {
    title: '4- 44444444444',
    picList: [MOCK_IMG, MOCK_IMG, MOCK_IMG],
    subInfo: ['三图评论', '11评'],
  },
};
const STYLE_5 = {
  style: 2,
  itemBean: {
    title: '5- 5555555555555',
    picUrl: MOCK_IMG2,
    subInfo: ['左文右图'],
  },
};
const STYLE_6 = {
  style: 5,
  itemBean: {
    title: '6- 66666666666666',
    picUrl: MOCK_COVER,
    subInfo: ['六眼神魔  5234播放'],
  },
};
const STYLE_7 = {
  style: 1,
  itemBean: {
    title: '7- 77777777777777',
    picList: [MOCK_IMG, MOCK_IMG, MOCK_IMG],
    subInfo: ['三图评论', '11评'],
  },
};
const STYLE_8 = {
  style: 2,
  itemBean: {
    title: '8 - 88888888888888888',
    picUrl: MOCK_IMG2,
    subInfo: ['左文右图'],
  },
};
const mockData = [STYLE_1, STYLE_2, STYLE_3, STYLE_4, STYLE_5];
const mockData1 = [STYLE_3, STYLE_4, STYLE_7, STYLE_8, STYLE_6, STYLE_1, STYLE_2, STYLE_5];
export default {
  data() {
    return {
      headerRefreshText: '继续下拉触发刷新',
      footerRefreshText: '正在加载...',
      dataSource: [],
      scrollPos: {
        top: 0,
        left: 0,
      },
      Vue,
      n: 0
    };
  },
  mounted() {
    // *** loadMoreDataFlag 是加载锁，业务请照抄 ***
    // 因为 onEndReach 位于屏幕底部时会多次触发，
    // 所以需要加一个锁，当未加载完成时不进行二次加载
    this.dataSource = [...mockData];
  },
  methods: {
    mockFetchData() {
      return new Promise((resolve) => {
        if ( this.n % 2 !== 0) {
          resolve(mockData);
        } else {
          resolve(mockData1);
        }
        this.n += 1;
      });
    },
    /**
     * 翻到下一页
     */
    async scrollToNextPage() {
      // 因为布局问题，浏览器内 flex: 1 后也会超出窗口尺寸高度，所以这么滚是不行的。
      const dataSource = await this.mockFetchData();
      this.dataSource = dataSource;
    },
  },
};
</script>

<style scoped>
#demo-pull-header-footer {
  flex: 1;
  padding: 12px;
}

#demo-pull-header-footer .ul-refresh {
  background-color: #40b883;
}

#demo-pull-header-footer .ul-refresh-text {
  color: white;
  height: 50px;
  line-height: 50px;
  text-align: center;
}

#demo-pull-header-footer .pull-footer {
  background-color: #40b883;
  height: 40px;
}

#demo-pull-header-footer .pull-footer-text {
  color: white;
  line-height: 40px;
  text-align: center;
}

#demo-pull-header-footer #list {
  flex: 1;
  background-color: white;
}

#demo-pull-header-footer .item-style {
  background-color: white;
  padding-top: 12px;
  padding-bottom: 12px;
  border-bottom-width: 1px;
  border-bottom-color: #e5e5e5;
  border-style: solid;
}

[specital-attr='pull-header-footer'] >>> .article-title {
  font-size: 17px;
  line-height: 24px;
  color: #242424;
}

[specital-attr='pull-header-footer'] >>> .normal-text {
  font-size: 11px;
  color: #aaa;
  align-self: center;
}

[specital-attr='pull-header-footer'] >>> .image {
  flex: 1;
  height: 160px;
  resize-mode: cover;
}

[specital-attr='pull-header-footer'] >>> .style-one-image-container {
  flex-direction: row;
  justify-content: center;
  margin-top: 8px;
  flex: 1;
}

[specital-attr='pull-header-footer'] >>> .style-one-image {
  height: 120px;
}

[specital-attr='pull-header-footer'] >>> .style-two {
  flex-direction: row;
  justify-content: space-between;
}

[specital-attr='pull-header-footer'] >>> .style-two-left-container {
  flex: 1;
  flex-direction: column;
  justify-content: center;
  margin-right: 8px;
}

[specital-attr='pull-header-footer'] >>> .style-two-image-container {
  flex: 1;
}

[specital-attr='pull-header-footer'] >>> .style-two-image {
  height: 140px;
}

[specital-attr='pull-header-footer'] >>> .style-five-image-container {
  flex-direction: row;
  justify-content: center;
  margin-top: 8px;
  flex: 1;
}

</style>
